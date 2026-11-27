# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that V's own parser (v.ast) gives.
module Representer::Languages::Vlang::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if x { return y }  ->  (if_expression x (block (return_statement y)))
    strip_tokens "module", "import", "const", "fn", "type", "struct", "enum", "interface", "map[", "if", "else",
                 "for", "match", "or", "return", "break", "continue", "defer", "go", "spawn", "thread", "assert",
                 "as", ":="

    # Strip `in` from a `for` loop, `unsafe` from an `unsafe` block and the
    # bars from a short lambda, where they always sit. Elsewhere `in` and `|`
    # are operators.
    strip_tokens "in", only_in: :range_clause
    strip_tokens "unsafe", only_in: :unsafe_expression
    strip_tokens "|", only_in: :short_lambda

    # Strip the brackets, separators and line breaks, because they are
    # layout. A `;` between statements is the same as a new line.
    # f(a, b)  ->  (call_expression f (argument_list a b))
    strip_tokens "(", ")", "{", "}", "[", "]", "@[", ",", ".", ":", ";", "\n", "\r", "\r\n"

    # Keep the `;` in a `for` clause, because it shows which part is which.
    # for i := 0; ; {} and for ; i < 9; {}
    keep_tokens ";", in: :for_clause

    # Unwrap brackets that only group, because the tree's shape shows the
    # grouping. Unwrap the nodes that only hold one other node too, because
    # V's parser has no node for them.
    # (a + b)  ->  a + b
    # x := 1  ->  (var_declaration (identifier_list x) (expression_list 1))
    unwrap :parenthesized_expression, :literal, :plain_type, :simple_statement, :reference_expression,
           :type_reference_expression, :field_name, :argument

    # Write each number as its value. V reads an integer that starts with
    # `0` as octal.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 0o17  ->  15
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
      %q(\') => "'",
      '\"' => '"',
      '\$' => "$"
    }.freeze

    CONTINUED = [
      "call_expression", "selector_expression", "index_expression", "slice_expression", "reference_expression",
      "literal", "parenthesized_expression", "array_creation"
    ].freeze

    # '$name!'  ->  name
    # '$a.b' and '$f()' don't match.
    SHORT_INTERPOLATION = /\A([A-Za-z_]\w*+)(?!\.[A-Za-z_]|[(\[])/

    def call
      tree.tap do
        join_the_lines_that_start_with_a_dot!
        write_strings_as_their_values!
        put_the_imports_straight_into_their_file!
        list_the_names_each_declaration_defines!
        mark_the_parameters_of_each_short_lambda!
        give_the_blank_identifier_its_own_type!
      end
    end

    private
    ### Lines ###

    # Join a line that starts with `.` to the expression at the end of the
    # line before it. V's parser reads the two lines as one expression, and
    # the grammar reads the second line as a statement that starts with an
    # enum value.
    # xs.filter(it > 0)\n.len  ->  xs.filter(it > 0).len
    def join_the_lines_that_start_with_a_dot!
      each_node(tree) do |node, _|
        next unless ["block", "source_file"].include?(node.type)

        node.children = node.children.each_with_object([]) do |child, kept|
          previous = kept.reverse.find(&:named?)
          kept << child unless previous && continue_line!(previous, child)
        end
      end
    end

    # Put the statement's leading `.name` after the end of the previous
    # statement, and the result in its place. Return whether it did.
    def continue_line!(previous, statement)
      parent, fetch = leading_dot(nil, statement)
      owner, last = line_end(nil, previous)
      return false unless fetch && owner && CONTINUED.include?(last.type)

      parent.replace_child(fetch, build(:selector_expression, { operand: last }, token("."),
                                        { field: fetch.named_children.first }))
      owner.replace_child(last, statement.named_children.first)
      true
    end

    # Return the `.name` that a statement starts with, and its parent.
    def leading_dot(parent, node)
      return [parent, node] if node.type == "enum_fetch"

      inner = case node.type
              when "simple_statement", "slice_expression", "or_block_expression" then node.named_children.first
              when "call_expression" then node[:name]
              when "selector_expression", "index_expression" then node[:operand]
              end
      inner ? leading_dot(node, inner) : nil
    end

    # Return the expression that a statement ends with, and its parent.
    def line_end(parent, node)
      inner = case node.type
              when "simple_statement" then node.named_children.first
              when "return_statement", "expression_list" then node.named_children.last
              when "var_declaration" then node[:expression_list]
              when "assignment_statement", "binary_expression" then node[:right]
              when "unary_expression" then node[:operand]
              end
      inner ? line_end(node, inner) : [parent, node]
    end

    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape, and a `$` that starts no `${}`, as a node of its own, so it
    # can't make two different strings the same. A raw string's value is its
    # text. A C string stays apart from a string, because its type differs.
    # "a"  ->  'a'
    # 'a\x41'  ->  'aA'
    # r'a\b'  ->  'a\\b'
    def write_strings_as_their_values!
      transform(tree, "(interpreted_string_literal) @string") do |match|
        string_node(read_short_interpolations(string_parts(match.node).map { |part| string_piece(part) }))
      end
      transform(tree, "(raw_string_literal) @string") do |match|
        literal(match.node.named_children.map(&:text).join)
      end
      transform(tree, "(c_string_literal) @string") do |match|
        pieces = read_short_interpolations(string_parts(match.node).map { |part| string_piece(part) })
        build(:c_string_literal, string_node(pieces))
      end
    end

    # Return a string's parts without its quotes.
    def string_parts(node) = node.children.select { |child| child.named? || child.text == "$" }

    # Return a string part's text, or its node if it isn't text.
    def string_piece(part)
      case part.type
      when "fragment" then part.text
      when "escape_sequence" then escape(part)
      when "string_interpolation" then interpolation(part)
      else part
      end
    end

    # Write an interpolation as the code inside it, with its format if it
    # has one.
    # '${a:5}'  ->  (string_interpolation a :5)
    def interpolation(node)
      parts = node.named_children.reject { |child| child.type.start_with?("interpolation_") && child.leaf? }
      parts = parts.map { |part| part.type == "interpolation_expression" ? part.named_children.first : part }
      build(:string_interpolation, *parts)
    end

    # Read a `$` and the name after it as an interpolation, as V's parser
    # does. Keep the `$` as it is if the name goes on with `.`, `(` or `[`.
    # 'a $b c'  ->  'a ${b} c'
    def read_short_interpolations(pieces)
      pieces.each_with_object([]) do |piece, read|
        name = piece[SHORT_INTERPOLATION, 1] if piece.is_a?(String) && dollar?(read.last)
        if name
          read[-1] = build(:string_interpolation, leaf(:identifier, name))
          piece = piece[name.length..]
        end
        read << piece unless piece == ""
      end
    end

    def dollar?(piece) = piece.is_a?(Representer::Engine::Node) && !piece.named? && piece.text == "$"

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
    # string of literals and other nodes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:interpreted_string_literal, *parts)
    end

    ### Imports ###

    # Put the imports straight into the file or block, as v.ast does.
    # import a\nimport b  ->  (source_file (import_declaration a) (import_declaration b))
    def put_the_imports_straight_into_their_file!
      each_node(tree) do |node, _|
        node.children = node.children.flat_map { |child| child.type == "import_list" ? child.children : [child] }
      end
    end

    ### Names ###

    # Put the names that `:=` defines in a list of their own, as v.ast marks
    # them, so representation.rb can list them as definitions.
    # a, mut b := 1, 2  ->  (var_declaration (identifier_list a (mutable_identifier mut b)) (expression_list 1 2))
    def list_the_names_each_declaration_defines!
      captured(tree, "(var_declaration var_list: (expression_list) @name)").each do |names|
        names.type = "identifier_list"
        names.children.each { |name| name.type = "mutable_identifier" if name.type == "mutable_expression" }
      end
    end

    # Mark the names between the bars of a short lambda as its parameters.
    # The last node is the lambda's body.
    # |x| x * 2  ->  (short_lambda (lambda_parameter x) (binary_expression x * 2))
    def mark_the_parameters_of_each_short_lambda!
      find_all(tree, "(short_lambda)").each do |match|
        match.node.named_children[0...-1].each { |parameter| parameter.type = "lambda_parameter" }
      end
    end

    # Give `_` a type of its own, because it defines no name.
    # for _, x in xs  ->  (range_clause (var_definition_list (var_definition (blank_identifier _)) ...) ...)
    def give_the_blank_identifier_its_own_type!
      each_node(tree) { |node, _| node.type = "blank_identifier" if node.type == "identifier" && node.text == "_" }
    end
  end
end
