# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Go's own parser (go/ast) gives.
module Representer::Languages::Go::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if x { return y }  ->  (if_statement x (block (statement_list (return_statement y))))
    strip_tokens "import", "package", "func", "type", "struct", "interface", "map", "var", "const", "if", "else",
                 "for", "switch", "select", "case", "default", "return", "range", "go", "defer", "break", "continue",
                 "goto", "fallthrough"

    # Strip the brackets, commas and other punctuation, because they are
    # layout. A `;` between statements is the same as a new line.
    # f(a, b)  ->  (call_expression f (argument_list a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ",", ".", ";"

    # Keep the `;` in a `for` clause, because it shows which part is which.
    # for i++; ; {} and for ; ; i++ {}
    keep_tokens ";", in: :for_clause

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized_expression, :parenthesized_type

    # Write each number as its value. Go reads an integer that starts with
    # `0` as octal.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 017  ->  15
    # 1.50  ->  1.5
    numbers_are integer: :int_literal,
                decimal: :float_literal,
                prefixes: { "0x" => 16, "0o" => 8, "0b" => 2, "0" => 8 }

    ESCAPES = {
      '\a' => "\a",
      '\b' => "\b",
      '\f' => "\f",
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\v' => "\v",
      '\\\\' => "\\",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        put_grouped_specs_in_their_declaration!
        give_the_blank_identifier_its_own_type!
        list_the_names_each_declaration_defines!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a node of its own, so it can't make two different strings
    # the same. Go drops the carriage returns from a raw string.
    # `a`  ->  "a"
    # "\x41é"  ->  "Aé"
    def write_strings_as_their_values!
      transform(tree, "(interpreted_string_literal) @string") do |match|
        string_node(match.node.named_children.map { |part| string_piece(part) })
      end
      transform(tree, "(raw_string_literal) @string") do |match|
        literal(match.node.named_children.map(&:text).join.delete("\r"))
      end
    end

    # Return a string part's text, or its node if it isn't text.
    def string_piece(part)
      case part.type
      when "interpreted_string_literal_content" then part.text
      when "escape_sequence" then escape(part)
      else part
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for no single character, such as half of a surrogate pair or a
    # byte above 127.
    def escape(node)
      code = node.text[1..]
      case code
      when /\A(?:u\h{4}|U\h{8})\z/
        value = code[1..].to_i(16)
        value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? node : [value].pack("U")
      when /\Ax\h{2}\z/ then ascii(code[1..].to_i(16), node)
      when /\A[0-7]{3}\z/ then ascii(code.to_i(8), node)
      else ESCAPES.fetch(node.text, node)
      end
    end

    def ascii(value, node) = value < 0x80 ? value.chr : node

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:interpreted_string_literal, *parts)
    end

    ### Declarations ###

    # Put the specs of a grouped `var` straight into the declaration, as
    # go/ast does for every grouped declaration. Write each spec of a
    # grouped `import` as an import of its own, because Go reads them the
    # same, and each import can then be dropped on its own.
    # var (a = 1)  ->  var a = 1
    # import ("a"; _ "b")  ->  import "a"; import _ "b"
    def put_grouped_specs_in_their_declaration!
      each_node(tree) do |node, _|
        node.children = node.children.flat_map do |child|
          next child.children if child.type == "var_spec_list"
          next [child] unless child.type == "import_declaration" && child.children.any? { |spec| spec.type == "import_spec_list" }

          child.children.find { |spec| spec.type == "import_spec_list" }.children.select(&:named?).map do |spec|
            build(:import_declaration, spec)
          end
        end
      end
    end

    ### Names ###

    # Give `_` a type of its own, because it defines no name.
    # for _, x := range xs  ->  (range_clause (expression_list (blank_identifier _) x) ...)
    def give_the_blank_identifier_its_own_type!
      each_node(tree) { |node, _| node.type = "blank_identifier" if node.type == "identifier" && node.text == "_" }
    end

    # Put the names that each declaration defines in a list of their own, as
    # go/ast does, so representation/spec.rb can list them as definitions.
    # var a, b int  ->  (var_spec (identifier_list a b) int)
    # a, b := f()  ->  (short_var_declaration (identifier_list a b) := (expression_list f()))
    def list_the_names_each_declaration_defines!
      each_node(tree) do |node, _|
        next unless [
          "var_spec", "const_spec", "field_declaration", "parameter_declaration", "type_parameter_declaration"
        ].include?(node.type)

        first = node.children.index { |child| child.field == "name" }
        next unless first

        names, others = node.children.partition { |child| child.field == "name" }
        names.each { |name| name.field = nil }
        node.children = others.insert(first, build(:identifier_list, *names).tap { |list| list.field = "name" })
      end

      pattern = '[(short_var_declaration left: (_) @name) (range_clause left: (_) @name ":=") ' \
                '(receive_statement left: (_) @name ":=") (type_switch_statement alias: (_) @name)]'
      captured(tree, pattern).each { |names| names.type = "identifier_list" }
    end
  end
end
