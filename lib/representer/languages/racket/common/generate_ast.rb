# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the forms that Racket's reader gives, and marks the names that each form
# defines.
module Representer::Languages::Racket::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, because Racket reads `()`, `[]` and `{}` as the
    # same list.
    # [x 1]  ->  (list x 1)
    strip_tokens "(", ")", "[", "]", "{", "}"

    # Strip the `#lang ` of the language line and the `#` of a vector,
    # because the node types already show them.
    # #lang racket  ->  (extension racket)
    # #(1 2)  ->  (vector (list 1 2))
    strip_tokens "#lang ", only_in: :extension
    strip_tokens "#", only_in: :vector

    # Write each number as its value. An exact number, such as `1`, and an
    # inexact one, such as `1.0`, stay apart, because Racket reads them as
    # different values. A number with an exactness prefix, such as `#e1.5`,
    # keeps its text.
    #
    # #x1F  ->  31
    # 1.50  ->  1.5
    # 1.  ->  1.0
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "#x" => 16, "#o" => 8, "#b" => 2, "#d" => 10 },
                separators: []

    QUOTES = {
      quote: "quote", quasiquote: "quasiquote", unquote: "unquote", unquote_splicing: "unquote-splicing",
      syntax: "syntax", quasisyntax: "quasisyntax", unsyntax: "unsyntax", unsyntax_splicing: "unsyntax-splicing"
    }.freeze

    ESCAPES = {
      '\a' => "\a", '\b' => "\b", '\t' => "\t", '\n' => "\n", '\v' => "\v", '\f' => "\f", '\r' => "\r",
      '\e' => "\e", '\"' => '"', "\\'" => "'", '\\\\' => "\\"
    }.freeze

    CHARACTER_NAMES = {
      0 => "nul", 8 => "backspace", 9 => "tab", 10 => "newline", 11 => "vtab", 12 => "page", 13 => "return",
      32 => "space", 127 => "rubout"
    }.freeze

    DEFINE_FORMS = ["define", "define/contract", "define/public", "define/private", "define/override",
                    "define/augment", "define/pubment", "define/public-final", "define/override-final",
                    "define-syntax", "define-syntax-rule"].freeze
    LAMBDA_FORMS = ["lambda", "λ"].freeze
    LET_FORMS = ["let", "let*", "letrec", "letrec*"].freeze
    LET_VALUES_FORMS = ["let-values", "let*-values", "letrec-values"].freeze
    MATCH_LET_FORMS = ["match-let", "match-let*", "match-letrec"].freeze
    FIELD_FORMS = ["init-field", "field", "init"].freeze
    FOLD_FORMS = %r{\Afor\*?/(fold|foldr|lists)\z}
    FOR_FORMS = %r{\Afor\*?(/.+)?\z}
    PATTERN_EXPRESSIONS = ["?", "app", "regexp", "pregexp"].freeze
    UNBOUND_PATTERNS = ["_", "...", "___", "else"].freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_booleans_and_characters_one_way!
        write_ratios_in_their_lowest_terms!
        write_hashes_with_their_kind!
        write_quotes_as_the_forms_they_stand_for!
        label_the_head_of_each_list!
        mark_the_names_each_form_defines!(tree)
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape, such as `\u0041`, as a leaf of its own, so it can't make two
    # different strings the same. A byte string and a regular expression
    # keep their kind.
    #
    # "say \"hi\""  ->  say "hi"
    # #"abc"  ->  (byte_string "abc")
    # #px"\\d+"  ->  (regex #px "\d+")
    # #<<END\nsay "hi"\nEND  ->  say "hi"
    def write_strings_as_their_values!
      transform(tree, "(string) @string") { |match| string(match.node.text) }
      transform(tree, "(here_string) @string") { |match| literal(match.node.text.lines[1...-1].join.chomp) }
      transform(tree, "(byte_string) @string") { |match| build(:byte_string, string(match.node.text[1..])) }
      transform(tree, "(regex) @regex") do |match|
        kind, text = match.node.text.match(/\A(#[rp]x#?)(.*)\z/m).captures
        build(:regex, token(kind), string(text))
      end
    end

    def string(text)
      pieces = text[1..-2].scan(/\\(?:[0-7]{1,3}|x\h{1,2}|u\h{1,4}|U\h{1,8}|.)|[^\\]+/m)
      return literal(value_of(pieces)) if pieces.all? { |piece| read?(piece) }

      runs = pieces.chunk_while { |a, b| read?(a) && read?(b) }
      build(:string, *runs.map { |run| read?(run.first) ? literal(value_of(run)) : leaf(:escape, run.first) })
    end

    def read?(piece) = !piece.start_with?("\\") || ESCAPES.key?(piece)

    def value_of(pieces) = pieces.sum("") { |piece| ESCAPES.fetch(piece, piece) }

    # Write each boolean and character one way, because the reader reads
    # these spellings as the same value.
    #
    # #true  ->  #t
    # #F  ->  #f
    # #\  ->  #\space
    # #\linefeed  ->  #\newline
    # #\u0041  ->  #\A
    def write_booleans_and_characters_one_way!
      each_node(tree) do |node, _|
        node.text = node.text.downcase[0, 2] if node.type == "boolean"
        node.text = character(node.text) if node.type == "character"
      end
    end

    def character(text)
      code = case text[2..]
             when "null" then 0
             when "linefeed" then 10
             when /\A[0-7]{3}\z/ then text[2..].to_i(8)
             when /\A[uU](\h+)\z/ then Regexp.last_match(1).to_i(16)
             when /\A\s\z/ then text[2].ord
             end
      return text unless code && code <= 0x10FFFF

      "#\\#{CHARACTER_NAMES.fetch(code) { [code].pack('U') }}"
    end

    # Write each ratio in its lowest terms, and as an integer if it is one,
    # because the reader reads `2/4` as `1/2`.
    # 2/4  ->  1/2
    # 4/2  ->  2
    def write_ratios_in_their_lowest_terms!
      each_node(tree) do |node, _|
        next unless node.type == "number" && (parts = node.text.match(%r{\A([-+]?\d+)/(\d+)\z}))
        next if parts[2].to_i.zero?

        value = Rational(parts[1].to_i, parts[2].to_i)
        node.text = value.denominator == 1 ? value.numerator.to_s : "#{value.numerator}/#{value.denominator}"
      end
    end

    # Give each hash its kind, because the grammar leaves the text out of
    # the tree, and `#hash` and `#hasheq` compare keys differently.
    # #hasheq((a . 1))  ->  (hash #hasheq (list (list a . 1)))
    def write_hashes_with_their_kind!
      transform(tree, "(hash (fragment) @kind (list) @entries)") do |match|
        build(:hash, token(match[:kind].text.downcase), match[:entries])
      end
    end

    # Write each quote mark as the form that the reader reads it as.
    # 'x  ->  (quote x)
    # `(a ,b)  ->  (quasiquote (a (unquote b)))
    def write_quotes_as_the_forms_they_stand_for!
      QUOTES.each do |type, name|
        transform(tree, "(#{type}) @quote") do |match|
          build(:list, leaf(:symbol, name), *match.node.named_children)
        end
      end
    end

    # Give the first item of each list the field name `head`, so that a code
    # pattern such as `(require {{...}})` only matches a list that starts
    # with `require`, and not `(list 1 require)`.
    def label_the_head_of_each_list!
      each_node(tree) do |node, _|
        node.named_children.first&.field = "head" if node.type == "list"
      end
    end

    ### Names ###

    # Wrap each name that a form defines in a `definition` node, so that
    # representation.rb can list it in names_are_defined_by. The forms are
    # definitions, functions and their parameters, local bindings, loops,
    # `match` patterns, structures and the fields of classes. A quoted form
    # is data, so it defines nothing.
    #
    # (define (area w) w)  ->  (define ((definition area) (definition w)) w)
    # (let ([x 1]) x)  ->  (let (((definition x) 1)) x)
    def mark_the_names_each_form_defines!(node)
      return if node.type == "list" && ["quote", "quasiquote", "syntax", "quasisyntax"].include?(head(node))

      mark_form!(node) if node.type == "list"
      node.children.each { |child| mark_the_names_each_form_defines!(child) }
    end

    def mark_form!(list)
      forms = list.named_children
      case head(list)
      when *DEFINE_FORMS then mark_header!(list, forms[1])
      when "define-values" then mark_symbols!(forms[1])
      when *LAMBDA_FORMS then mark_parameters!(list, forms[1])
      when "case-lambda" then forms[1..].each { |clause| mark_parameters!(clause, clause.named_children.first) if list?(clause) }
      when *LET_FORMS then mark_let!(list, forms)
      when *LET_VALUES_FORMS then mark_bindings!(forms[1]) { |binding| mark_binding_or_symbols!(binding) }
      when "let/ec", "let/cc" then wrap!(list, forms[1])
      when "do" then mark_bindings!(forms[1])
      when FOLD_FORMS then mark_fold!(list, forms)
      when FOR_FORMS then mark_bindings!(forms[1]) { |binding| mark_binding_or_symbols!(binding) }
      when "match" then mark_clauses!(forms[2..])
      when "match*" then mark_clauses!(forms[2..], several: true)
      when "match-lambda" then mark_clauses!(forms[1..])
      when "match-lambda*" then mark_clauses!(forms[1..], several: true)
      when "match-define" then mark_pattern!(list, forms[1])
      when *MATCH_LET_FORMS then mark_bindings!(forms[1]) { |binding| mark_pattern!(binding, binding.named_children.first) }
      when "struct", "define-struct" then mark_structure!(list, forms)
      when "class", "class*" then mark_fields!(forms)
      end
    end

    def head(list) = list.named_children.first&.then { |node| symbol?(node) ? node.text : nil }

    def symbol?(node) = node&.type == "symbol"

    def list?(node) = node&.type == "list"

    def keyword?(node) = node&.type == "keyword"

    def wrap!(parent, node)
      parent.replace_child(node, build(:definition, node)) if symbol?(node)
    end

    # Wrap a symbol, or the first symbol of a binding such as `[x 1]`.
    def mark_binding!(parent, node)
      list?(node) ? wrap!(node, node.named_children.first) : wrap!(parent, node)
    end

    # Mark each binding of a list such as `([x 1] [y 2])`, or pass it to the
    # block. A keyword in the list, such as `#:when`, is followed by an
    # expression, which defines nothing.
    def mark_bindings!(list)
      return unless list?(list)

      after_keyword = false
      list.named_children.each do |binding|
        if keyword?(binding) then after_keyword = true
        elsif after_keyword then after_keyword = false
        elsif block_given? then yield binding
        else mark_binding!(list, binding)
        end
      end
    end

    def mark_symbols!(list)
      list.named_children.each { |node| wrap!(list, node) } if list?(list)
    end

    # (for ([x xs]) ...) defines x, and (for ([(k v) h]) ...) defines k and v.
    def mark_binding_or_symbols!(binding)
      return unless list?(binding)

      first = binding.named_children.first
      list?(first) ? mark_symbols!(first) : wrap!(binding, first)
    end

    # (define x 1) defines x, (define (f x) ...) defines f and x, and
    # (define ((f a) b) ...) defines f, a and b.
    def mark_header!(parent, header)
      return wrap!(parent, header) unless list?(header)

      name, *parameters = header.named_children
      list?(name) ? mark_header!(header, name) : wrap!(header, name)
      mark_each_parameter!(header, parameters)
    end

    # (lambda (x) ...) defines x, and (lambda args ...) defines args.
    def mark_parameters!(parent, parameters)
      list?(parameters) ? mark_each_parameter!(parameters, parameters.named_children) : wrap!(parent, parameters)
    end

    # Mark plain parameters, optional ones such as `[x 1]`, keyword ones
    # such as `#:by [by 1]`, and the rest after `.`.
    def mark_each_parameter!(list, parameters)
      parameters.each { |parameter| mark_binding!(list, parameter) }
    end

    # (let loop ([i 0]) ...) defines loop and i.
    def mark_let!(list, forms)
      if symbol?(forms[1])
        wrap!(list, forms[1])
        mark_bindings!(forms[2])
      else
        mark_bindings!(forms[1])
      end
    end

    # (for/fold ([total 0]) ([x xs]) ...) defines total and x.
    def mark_fold!(list, forms)
      head(list).end_with?("lists") ? mark_symbols!(forms[1]) : mark_bindings!(forms[1])
      mark_bindings!(forms[2]) { |binding| mark_binding_or_symbols!(binding) }
    end

    # (struct point (x [y #:mutable])) defines point, x and y. A parent
    # structure, as in (struct point3 point (z)), is a use of a name.
    def mark_structure!(list, forms)
      wrap!(list, forms[1])
      fields = forms[2..].find { |form| list?(form) }
      fields&.named_children&.each { |field| mark_binding!(fields, field) }
    end

    # Mark the fields of a class.
    # (class object% (init-field name [age 0]) ...) defines name and age.
    def mark_fields!(forms)
      forms.each { |form| form.named_children[1..].each { |field| mark_binding!(form, field) } if FIELD_FORMS.include?(head(form)) }
    end

    # Mark the patterns of each clause of a `match`. In `match*` and
    # `match-lambda*`, each clause starts with a list of patterns.
    # (match x [(cons a b) a])  ->  (match x ((cons (definition a) (definition b)) a))
    def mark_clauses!(clauses, several: false)
      clauses.each do |clause|
        next unless list?(clause)

        patterns = clause.named_children.first
        next mark_pattern!(clause, patterns) unless several

        patterns.named_children.each { |pattern| mark_pattern!(patterns, pattern) } if list?(patterns)
      end
    end

    # Mark the names that a `match` pattern binds. The head of a list
    # pattern, such as `list` or `cons`, names the shape. The first argument
    # of `?` and `app` is an expression, and the first of `regexp` is the
    # expression to match.
    # [(list a (? number? b)) ...] defines a and b.
    def mark_pattern!(parent, pattern)
      if symbol?(pattern)
        wrap!(parent, pattern) unless UNBOUND_PATTERNS.include?(pattern.text)
      elsif list?(pattern) && head(pattern) && !QUOTES.value?(head(pattern))
        items = pattern.named_children[1..]
        items = items[1..] if PATTERN_EXPRESSIONS.include?(head(pattern))
        items.each { |item| mark_pattern!(pattern, item) }
      end
    end
  end
end
