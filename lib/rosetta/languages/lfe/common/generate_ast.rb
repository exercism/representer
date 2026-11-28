# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the forms that LFE's own reader gives, which are lists, symbols and values,
# and marks the names that each form defines.
module Rosetta::Languages::Lfe::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Label the first item of each list as its head, so that the import
    # `(include-lib {{...}})` matches `(include-lib "lfe/include/clj.lfe")`,
    # and doesn't match `(list 1 include-lib)`.
    lists_are :list

    # Write each number as its value. LFE reads `1` as an integer and `1.0`
    # as a float, so the two stay apart.
    #
    # #x1F  ->  31
    # #b101  ->  5
    # 1.50  ->  1.5
    numbers_are integer: :integer,
                decimal: :float,
                prefixes: { "#x" => 16, "#o" => 8, "#b" => 2, "#*" => 2, "#d" => 10, "#16r" => 16, "#10r" => 10,
                            "#8r" => 8, "#2r" => 2 }

    OPEN = ["(", "["].freeze
    CLOSE = [")", "]"].freeze

    # The heads that LFE's reader gives for its quote marks.
    QUOTES = { quoted_list: "quote", quoted_form: "quote", quasiquote: "backquote", unquote: "comma",
               unquote_splicing: "comma-at" }.freeze

    ESCAPES = { '\n' => "\n", '\t' => "\t", '\\\\' => "\\", '\"' => '"' }.freeze

    # The forms whose first item after the head is a list of bindings, each
    # a pattern and its value, as in (let ((x 1)) x).
    LET_FORMS = ["let", "let*"].freeze

    # The forms whose first item after the head is a list of local functions,
    # as in (flet ((double (x) (* 2 x))) (double 3)).
    LOCAL_FUNCTION_FORMS = ["flet", "flet*", "fletrec", "let-function", "letrec-function", "let-macro"].freeze

    def call
      tree.tap do |root|
        write_every_form_as_the_reader_gives_it!(root)
        mark_the_names_each_form_defines!(root)
      end
    end

    private
    ### Forms ###

    # Write the tree as the lists, symbols and values that LFE's reader
    # gives. The grammar gives `defun`, `let`, `case` and other forms nodes
    # of their own, and the reader gives every form as a list. The reader
    # reads `[` as `(`, reads each quote mark as a form, and reads the words
    # of a form, such as `defun`, as symbols.
    #
    # (defun f [x] x)  ->  (list defun f (list x) x)
    # '(a b)  ->  (list quote (list a b))
    # #'f/2  ->  (list function f 2)
    def write_every_form_as_the_reader_gives_it!(root)
      root.children = items(root.children)
    end

    # Return the forms that a node of the grammar's tree gives, which can
    # be none, one or several.
    def forms(node)
      case node.type
      when "integer", "float" then [from(node, leaf(node.type, node.text))]
      when "list_string" then [string(node, node.text[1...-1])]
      when "binary_string" then [build(:binary, string(node, node.text[2...-1]))]
      when "binary" then node.children.one? ? forms(node.children.first) : [build(:binary, *items(node.children[1...-1]))]
      when "character" then [character(node)]
      when "delimited_symbol" then [from(node, symbol(node.text[1...-1].gsub("\\|", "|")))]
      when "atom" then [quote("quote", from(node.children.last, symbol(node.children.last.text)))]
      when *QUOTES.keys.map(&:to_s) then [quote(QUOTES.fetch(node.type.to_sym), *items(node.children))]
      when "function_reference" then [quote("function", *items(node.children))]
      when "tuple", "map" then [build(node.type, *items(node.children[1...-1]))]
      else node.children.empty? ? [from(node, symbol(node.text))] : items(node.children)
      end
    end

    # Return the forms that a node's children give. Each pair of brackets
    # makes a list, and each word of the grammar, such as `defun`, is a
    # symbol.
    def items(children)
      lists = [[]]
      children.each do |child|
        if OPEN.include?(child.type) then lists.push([])
        elsif CLOSE.include?(child.type) then lists[-2] << build(:list, *lists.pop)
        elsif child.named? || child.children.any? then lists.last.concat(forms(child))
        elsif child.text.match?(/\A[[:alpha:]?=]/) then lists.last << from(child, symbol(child.text))
        end
      end
      lists.first
    end

    # Keep the place in the source of each leaf, which code patterns need
    # to find their code.
    def from(node, leaf) = leaf.tap { leaf.span = node.span }

    def symbol(name) = leaf(:symbol, name)

    def quote(head, *forms) = build(:list, symbol(head), *forms)

    # Write each string as its value, and read its escapes. Keep a string
    # with any other escape as it is written, in a node of its own, so two
    # different strings can never get the same value.
    # "say \"hi\""  ->  (literal "say \"hi\"")
    # "a\x41;b"  ->  (escaped_string "a\x41;b")
    def string(node, text)
      return build(:escaped_string, from(node, leaf(:string, text))) if text.gsub(/\\[nt\\"]/, "").include?("\\")

      from(node, literal(text.gsub(/\\[nt\\"]/) { |escape| ESCAPES.fetch(escape) }))
    end

    # Write each character in a node of its own, so it stays apart from a
    # string with the same text. The reader reads `#\x41;` and `#\A` as the
    # same character.
    # #\x41;  ->  (character #\A)
    def character(node)
      code = node.text[/\A#\\x(\h+);\z/, 1]
      build(:character, from(node, leaf(:char, code ? "#\\#{code.hex.chr(Encoding::UTF_8)}" : node.text)))
    end

    ### Names ###

    # Wrap each name that a form defines in a `definition` node, so that
    # representation/spec.rb can list it in names_are_defined_by. Every
    # symbol in a pattern defines a variable, apart from the head of a
    # constructor such as `tuple` or `cons`, and the contents of a quote.
    #
    # (defun area (w) w)  ->  (list defun (definition area) (list (definition w)) w)
    # (case x ((tuple a b) a))  ->  (list case x (list (list tuple (definition a) (definition b)) a))
    def mark_the_names_each_form_defines!(root)
      each_node(root) { |node, parent| mark_form!(node, parent) if node.type == "list" }
    end

    def mark_form!(list, parent)
      _, *args = list.children
      case head_text(list)
      when "defmodule" then define!(args.first)
      when "defun", "defmacro" then mark_function!(args)
      when "lambda" then mark_patterns!(args.first)
      when "match-lambda" then args.each { |clause| mark_clause!(clause, patterns: true) }
      when *LET_FORMS then each_item(args.first) { |binding| mark_clause!(binding) }
      when *LOCAL_FUNCTION_FORMS then each_item(args.first) { |function| mark_local_function!(function) }
      when "case" then args.drop(1).each { |clause| mark_clause!(clause) }
      when "receive" then args.each { |clause| mark_clause!(clause) }
      when "catch" then args.each { |clause| mark_clause!(clause) } if head_text(parent) == "try"
      when "?=", "<-", "<=" then mark_pattern!(args.first)
      when "defrecord" then mark_record!(args)
      end
    end

    # (defun f (x y) ...) defines f, x and y.
    # (defun f "Adds." ((0 y) ...) ((x y) ...)) defines f, x and y.
    def mark_function!(args)
      name, *rest = args
      define!(name)
      rest.shift if rest.first&.type == "literal"
      if simple_parameters?(rest.first) then mark_patterns!(rest.first)
      else rest.each { |clause| mark_function_clause!(clause) }
      end
    end

    def simple_parameters?(node) = node&.type == "list" && node.children.all? { |item| symbol?(item) }

    # ((x 0) (when (> x 1)) body) defines x.
    def mark_function_clause!(clause)
      mark_patterns!(clause.children.first) if clause.type == "list"
    end

    # (name (x) body) defines name and x.
    # (name (lambda (x) body)) defines name.
    def mark_local_function!(function)
      name, parameters = function.children
      define!(name)
      mark_patterns!(parameters) if parameters&.type == "list" && head_text(parameters) != "lambda"
    end

    # A clause of `case`, `receive`, `catch` and a binding of `let` start
    # with their pattern. A clause of `match-lambda` starts with a list of
    # patterns, one for each argument. The `after` of `receive` has no
    # pattern.
    # ((tuple a b) a) defines a and b.
    def mark_clause!(clause, patterns: false)
      return unless clause.type == "list" && head_text(clause) != "after"

      patterns ? mark_patterns!(clause.children.first) : mark_pattern!(clause.children.first)
    end

    # (defrecord robot x (y 0)) defines robot, x and y.
    def mark_record!(args)
      name, *fields = args
      define!(name)
      fields.each { |field| define!(field.type == "list" ? field.children.first : field) }
    end

    # Mark each item of a list as a pattern, as in the parameters of a
    # function.
    # (x (cons h t)) defines x, h and t.
    def mark_patterns!(list)
      each_item(list) { |pattern| mark_pattern!(pattern) }
    end

    # Mark the variables of one pattern. The first item of a list in a
    # pattern names its constructor, and each segment of a binary starts
    # with its variable.
    # (tuple 'ok x) defines x.
    # (binary (a (size 8)) (rest binary)) defines a and rest.
    def mark_pattern!(pattern)
      return define!(pattern) if symbol?(pattern)
      return unless pattern&.type == "list"

      _, *args = pattern.children
      case head_text(pattern)
      when "quote" then nil
      when "binary" then args.each { |segment| mark_pattern!(segment.type == "list" ? segment.children.first : segment) }
      else args.each { |arg| mark_pattern!(arg) }
      end
    end

    def define!(node)
      return unless symbol?(node) && node.text != "_"

      node.children = [from(node, symbol(node.text))]
      node.text = nil
      node.type = "definition"
    end

    def each_item(list, &)
      list.children.dup.each(&) if list&.type == "list"
    end

    def symbol?(node) = node&.type == "symbol"

    def head_text(list)
      first = list&.children&.first
      first.text if symbol?(first)
    end
  end
end
