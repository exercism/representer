# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the data that Scheme's reader gives, and marks the names that each form
# defines.
module Representer::Languages::Scheme::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the brackets, because the node types already show them. The
    # reader reads square brackets as round ones.
    # [x 1]  ->  (list x 1)
    # #(1 2)  ->  (vector 1 2)
    strip_tokens "(", ")", "[", "]", "#(", "#u8(", "#vu8("

    # Label the first item of each list as its head, so that the import
    # `(import {{...}})` matches `(import (rnrs))`, and doesn't match
    # `(list 1 import)`.
    lists_are :list

    # Write each number as its value. An exact number and an inexact one stay
    # apart, because the reader gives them different types. A rational and a
    # number with an exactness prefix keep their text.
    #
    # #x1F  ->  31
    # +7  ->  7
    # 1.50  ->  1.5
    # 1e3  ->  1000.0
    numbers_are integer: :number,
                decimal: :number,
                prefixes: { "#x" => 16, "#o" => 8, "#b" => 2, "#d" => 10 },
                separators: []

    ABBREVIATIONS = {
      "quote" => "quote",
      "quasiquote" => "quasiquote",
      "unquote" => "unquote",
      "unquote_splicing" => "unquote-splicing",
      "syntax_quote" => "syntax",
      "quasisyntax" => "quasisyntax",
      "unsyntax" => "unsyntax",
      "unsyntax_splicing" => "unsyntax-splicing"
    }.freeze

    ESCAPES = { "\\n" => "\n", "\\\\" => "\\", "\\\"" => '"' }.freeze

    CHARACTER_NAMES = { "space" => " ", "newline" => "\n" }.freeze

    DEFINE_FORMS = ["define", "define*", "define-public", "define-syntax", "define-peg-pattern"].freeze
    LAMBDA_FORMS = ["lambda", "lambda*"].freeze
    LET_FORMS = ["let", "let*", "letrec", "letrec*", "let-syntax", "letrec-syntax"].freeze
    LET_VALUES_FORMS = ["let-values", "let*-values"].freeze
    FORMALS_FORMS = ["define-values", "receive"].freeze
    RECORD_CLAUSES = ["fields", "parent", "protocol", "sealed", "opaque", "nongenerative", "parent-rtd"].freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        write_characters_as_their_values!
        write_booleans_as_their_values!
        write_abbreviations_as_lists!
        mark_the_names_each_form_defines!
      end
    end

    private
    ### Values ###

    # Turn each string into its value. A string with an escape that this
    # stage doesn't read keeps its text inside a `string` node, so two
    # different strings can never get the same value.
    # "say \"hi\""  ->  say "hi"
    # "a\tb"  ->  (string "\"a\\tb\"")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        body = match.node.text[1...-1]
        next build(:string, leaf(:source, match.node.text)) unless body.scan(/\\./m).all? { |escape| ESCAPES.key?(escape) }

        literal(body.gsub(/\\./m, ESCAPES))
      end
    end

    # Write each character the same way however its name is spelled,
    # because the reader reads them as the same character. A name that this
    # stage doesn't read keeps its text.
    # #\Space  ->  #\space
    # #\NEWLINE  ->  #\newline
    def write_characters_as_their_values!
      each_node(tree) do |node, _|
        next unless node.type == "character" && node.leaf?

        name = node.text.delete_prefix("#\\")
        node.text = "#\\#{name.downcase}" if CHARACTER_NAMES.key?(name.downcase)
      end
    end

    # Write `#true` and `#false` as `#t` and `#f`, because the reader reads
    # them as the same booleans.
    # #true  ->  #t
    def write_booleans_as_their_values!
      each_node(tree) do |node, _|
        node.text = node.text[0, 2] if node.type == "boolean" && ["#true", "#false"].include?(node.text)
      end
    end

    # Write each quote mark as the list that the reader gives.
    # 'x  ->  (quote x)
    # `(a ,b)  ->  (quasiquote (a (unquote b)))
    def write_abbreviations_as_lists!
      ABBREVIATIONS.each do |type, head|
        transform(tree, "(#{type}) @form") { |match| build(:list, leaf(:symbol, head), *match.node.named_children) }
      end
    end

    ### Names ###

    # Wrap each name that a form defines in a `definition` node, so that
    # representation/spec.rb can list them in names_are_defined_by. The forms
    # are definitions with their parameters, lambdas, local bindings, loops,
    # records, macros and condition handlers.
    #
    # (define (area w) w)  ->  (define ((definition area) (definition w)) w)
    # (let ((x 1)) x)  ->  (let (((definition x) 1)) x)
    def mark_the_names_each_form_defines!
      each_node(tree) { |node, _| mark_form!(node) if node.type == "list" }
    end

    def mark_form!(list)
      forms = list.named_children
      case head(list)
      when *DEFINE_FORMS then mark_definition!(list, forms[1])
      when *LAMBDA_FORMS, *FORMALS_FORMS then mark_formals!(list, forms[1])
      when "case-lambda" then each_binding(list, skip: 1) { |clause| mark_formals!(clause, clause.named_children.first) }
      when *LET_FORMS then mark_let!(list, forms[1..])
      when *LET_VALUES_FORMS then each_binding(forms[1]) { |binding| mark_formals!(binding, binding.named_children.first) }
      when "do" then each_binding(forms[1]) { |binding| mark!(binding, binding.named_children.first) }
      when "guard" then mark!(forms[1], forms[1].named_children.first) if list?(forms[1])
      when "define-record-type" then mark_record!(list, forms[1..])
      when "syntax-rules" then mark_pattern_variables!(forms[1], forms[2..])
      end
    end

    def head(list) = list.named_children.first&.then { |node| symbol?(node) ? node.text : nil }

    def symbol?(node) = node&.type == "symbol"

    def list?(node) = node&.type == "list"

    def mark!(parent, node)
      parent.replace_child(node, build(:definition, node)) if symbol?(node)
    end

    def each_binding(bindings, skip: 0, &)
      bindings.named_children.drop(skip).select { |binding| list?(binding) }.each(&) if list?(bindings)
    end

    # (define total 0) defines total.
    # (define (area w h) ...) defines area, w and h.
    # (define ((adder n) x) ...) defines adder, n and x.
    def mark_definition!(list, target)
      return mark!(list, target) unless list?(target)

      name = target.named_children.first
      list?(name) ? mark_definition!(target, name) : mark!(target, name)
      mark_formals!(list, target, skip: 1)
    end

    # Mark each parameter of a lambda list, including the rest parameter
    # after a dot and the optional parameters of `lambda*`, such as `(b 1)`.
    # A lambda list that is one symbol takes every argument as a list.
    # (lambda (a . rest) ...) defines a and rest.
    # (lambda args ...) defines args.
    def mark_formals!(parent, formals, skip: 0)
      return mark!(parent, formals) unless list?(formals)

      formals.named_children.drop(skip).each do |parameter|
        list?(parameter) ? mark!(parameter, parameter.named_children.first) : mark!(formals, parameter)
      end
    end

    # (let ((x 1)) ...) defines x.
    # (let loop ((i 0)) ...) defines loop and i.
    def mark_let!(list, forms)
      if symbol?(forms.first)
        mark!(list, forms.first)
        forms = forms.drop(1)
      end
      each_binding(forms.first) { |binding| mark!(binding, binding.named_children.first) }
    end

    # Mark the names of a record type: its type, constructor, predicate,
    # fields, accessors and modifiers. A record written in R6RS's form has
    # clauses such as `(fields ...)`, and the others are written in the form
    # of SRFI 9 and R7RS.
    # (define-record-type <point> (make-point x y) point? (x point-x)) defines all six.
    # (define-record-type point (fields x (mutable y))) defines point, x and y.
    def mark_record!(list, forms)
      return mark_r6rs_record!(list, forms) if forms.drop(1).any? { |clause| record_clause?(clause) }

      type, constructor, predicate, *fields = forms
      mark!(list, type)
      mark!(constructor, constructor.named_children.first) if list?(constructor)
      mark!(list, predicate)
      fields.each { |field| mark_every_symbol!(field) }
    end

    def record_clause?(node) = list?(node) && RECORD_CLAUSES.include?(head(node))

    def mark_r6rs_record!(list, forms)
      name, *clauses = forms
      list?(name) ? mark_every_symbol!(name) : mark!(list, name)
      clauses.each do |clause|
        next unless head(clause) == "fields"

        clause.named_children.drop(1).each do |field|
          list?(field) ? mark_every_symbol!(field, skip: 1) : mark!(clause, field)
        end
      end
    end

    def mark_every_symbol!(list, skip: 0)
      list.named_children.drop(skip).each { |node| mark!(list, node) } if list?(list)
    end

    # Mark the pattern variables of each rule, which are every symbol in its
    # pattern apart from the macro's own name, `...`, `_` and the literals.
    # (syntax-rules () ((_ a b) (if a b #f))) defines a and b.
    def mark_pattern_variables!(literals, rules)
      kept = ["_", "..."] + (list?(literals) ? literals.named_children.map(&:text) : [])
      rules.each do |rule|
        pattern = rule.named_children.first if list?(rule)
        next unless list?(pattern)

        each_node(pattern) do |node, parent|
          mark!(parent, node) unless node.equal?(pattern.named_children.first) || kept.include?(node.text)
        end
      end
    end
  end
end
