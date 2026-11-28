# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Julia's own parser (`Meta.parse`) gives.
module Rosetta::Languages::Julia::Common
  class GenerateAST < Rosetta::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if a b else c end  ->  (if_statement a (block b) (else_clause (block c)))
    strip_tokens "function", "macro", "struct", "abstract", "primitive", "type", "end", "return", "if", "elseif",
                 "else", "for", "while", "do", "let", "try", "catch", "finally", "quote", "where", "const", "local",
                 "global", "break", "continue", "using", "import", "export", "public", "as"

    # Strip these keywords only where they sit in a fixed place. Keep
    # `baremodule`, because it makes a different kind of module.
    # begin a end  ->  (compound_statement (block a))
    strip_tokens "begin", only_in: :compound_statement
    strip_tokens "module", only_in: :module_definition

    # Strip the brackets, commas and semicolons, because they are layout. A
    # trailing comma and a `;` between statements make no difference.
    # f(a, b,)  ->  (call_expression f (argument_list a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";"

    # Keep the `;` in arguments and tuples, because the names after it are
    # keywords, and in matrices, because `[a;; b]` and `[a; b]` join their
    # items along different dimensions.
    # f(a; b=1)  and  f(a, b=1)
    keep_tokens ";", in: [:argument_list, :tuple_expression, :matrix_expression]

    # Strip the marks that sit in a fixed place, because the node types
    # already show them.
    # x::Int  ->  (typed_expression x Int)
    # a ? b : c  ->  (ternary_expression a b c)
    strip_tokens "::", only_in: [:typed_expression, :unary_typed_expression]
    strip_tokens "...", only_in: :splat_expression
    strip_tokens "->", only_in: :arrow_function_expression
    strip_tokens "?", ":", only_in: :ternary_expression
    strip_tokens ":", only_in: [:range_expression, :quote_expression]
    strip_tokens ".", only_in: [:field_expression, :broadcast_call_expression]
    strip_tokens "@", only_in: :macro_identifier
    strip_tokens "'", only_in: :adjoint_expression
    strip_tokens "$", only_in: :string_interpolation

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each decimal integer and each floating-point number as its value.
    # A hexadecimal, octal or binary integer keeps its text, because its
    # number of digits sets its type, so `0x1F` is a `UInt8` and `31` is an
    # `Int`. A `Float32` such as `1.5f0` keeps its text too.
    #
    # 1_000  ->  1000
    # 1e3  ->  1000.0
    # 1.50  ->  1.5
    numbers_are integer: :integer_literal,
                decimal: :float_literal,
                prefixes: {}

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\a' => "\a",
      '\b' => "\b",
      '\f' => "\f",
      '\v' => "\v",
      '\e' => "\e",
      '\0' => "\0",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'",
      '\$' => "$"
    }.freeze

    def call
      tree.tap do
        write_every_loop_binding_the_same_way!
        write_juxtaposition_as_multiplication!
        give_keyword_arguments_their_own_type!
        mark_the_names_that_definitions_define!
        write_characters_as_their_values!
        write_strings_as_their_values!
      end
    end

    private
    # Drop the operator of each loop binding, because Julia's parser reads
    # `in`, `=` and `∈` there as the same.
    # for i = 1:3  ->  (for_binding i 1:3)
    # for i ∈ 1:3  ->  (for_binding i 1:3)
    def write_every_loop_binding_the_same_way!
      captured(tree, "(for_binding) @name").each do |binding|
        binding.children.reject! { |child| child.type == "operator" && ["in", "=", "∈"].include?(child.text) }
      end
    end

    # Write a number before an expression as a multiplication, because
    # Julia's parser reads `2x` and `2 * x` as the same call to `*`.
    # 2x  ->  (binary_expression 2 * x)
    def write_juxtaposition_as_multiplication!
      captured(tree, "(juxtaposition_expression) @name").each do |product|
        number, factor = product.named_children
        product.type = "binary_expression"
        product.children = [number, leaf(:operator, "*"), factor]
      end
    end

    # Give each `=` inside an argument list a type of its own, as Julia's
    # parser does with its `kw` node, because it names a keyword or gives a
    # parameter its default, and assigns to nothing.
    # f(x, by = length)  ->  (call_expression f (argument_list x (keyword_argument by = length)))
    def give_keyword_arguments_their_own_type!
      each_node(tree) do |node, parent|
        node.type = "keyword_argument" if node.type == "assignment" && parent&.type == "argument_list"
      end
    end

    ### Names ###

    # Put each name that a definition defines in the field `name`, so that
    # representation/spec.rb can list the nodes that hold them. Julia's grammar
    # gives the same node types to definitions and to other code, such as a
    # call and a function's signature, so only the place of a name shows that
    # it is defined.
    #
    # function «area»(«width», «height»::Int) ... end
    # «area»(«width») = width * 2
    # «a», «b» = pair
    # struct «Point»{«T»} «x»::T end
    def mark_the_names_that_definitions_define!
      each_node(tree) do |node, _|
        case node.type
        when "function_definition", "macro_definition"
          signature = node.children.find { |child| child.type == "signature" }
          mark_signature(signature.named_children.first) if signature
        when "assignment" then mark_assignment(node.named_children.first)
        when "compound_assignment_expression", "for_binding", "arrow_function_expression"
          mark_variables(node.named_children.first)
        when "do_clause" then node.named_children.reject { |child| child.type == "block" }.each { mark_variables(it) }
        when "let_statement", "local_statement", "global_statement", "catch_clause"
          node.named_children.each { |child| mark(child) if child.type == "identifier" }
        when "struct_definition", "abstract_definition", "primitive_definition" then mark_type(node)
        end
      end
    end

    # The left of `=` defines a function if it is a call, such as `f(x)`, and
    # its variables otherwise.
    def mark_assignment(left)
      signature?(left) ? mark_signature(left) : mark_variables(left)
    end

    def signature?(node)
      return true if node.type == "call_expression"

      ["typed_expression", "where_expression"].include?(node.type) && signature?(node.named_children.first)
    end

    # Mark a function's name, its parameters, and the type parameters after
    # `where`. A function without a name, such as `function (x) ... end`,
    # has only its parameters.
    # function «f»(«x»::T)::T where {«T» <: Number}
    def mark_signature(node)
      case node.type
      when "where_expression"
        mark_signature(node.named_children.first)
        node.named_children.drop(1).each { |parameter| mark_type_parameter(parameter) }
      when "typed_expression" then mark_signature(node.named_children.first)
      when "call_expression"
        function_name, arguments = node.named_children
        mark(function_name) if function_name.type == "identifier"
        mark_variables(arguments) if arguments&.type == "argument_list"
      when "argument_list" then mark_variables(node)
      end
    end

    # Mark the variables in a parameter or in the left of an assignment.
    # «x»::Int, «x» = 1, «xs»..., («a», «b»)
    def mark_variables(node)
      case node.type
      when "identifier" then mark(node)
      when "typed_expression", "keyword_argument", "splat_expression" then mark_variables(node.named_children.first)
      when "argument_list", "tuple_expression", "open_tuple" then node.named_children.each { mark_variables(it) }
      end
    end

    # Mark the name of a struct or other type, its type parameters and the
    # fields of a struct.
    # struct «Point»{«T»} <: Shape «x»::T end
    def mark_type(definition)
      head = definition.children.find { |child| child.type == "type_head" }
      mark_type_name(head.named_children.first) if head
      body = definition.children.find { |child| child.type == "block" }
      body&.named_children&.each { |field| mark_variables(field) if ["identifier", "typed_expression"].include?(field.type) }
    end

    def mark_type_name(node)
      case node.type
      when "identifier" then mark(node)
      when "binary_expression" then mark_type_name(node.named_children.first)
      when "parametrized_type_expression"
        name, parameters = node.named_children
        mark_type_name(name)
        mark_type_parameter(parameters) if parameters
      end
    end

    # where «T», where {«T» <: Number, «S»}
    def mark_type_parameter(node)
      case node.type
      when "identifier" then mark(node)
      when "binary_expression" then mark_type_parameter(node.named_children.first)
      when "curly_expression" then node.named_children.each { mark_type_parameter(it) }
      end
    end

    def mark(name)
      name.field = "name" if name.type == "identifier"
    end

    ### Values ###

    # Turn each character into its value, and read its escapes. A character
    # keeps a node of its own, so `'a'` and `"a"` stay apart.
    # 'é'  ->  (character_literal "é")
    def write_characters_as_their_values!
      transform(tree, "(character_literal) @character") do |match|
        pieces = escaped_pieces(match.node.text[1...-1])
        build(:character_literal, *pieces.map { |piece| piece.is_a?(String) ? literal(piece) : piece })
      end
    end

    # Turn each string into its value, and read its escapes. Julia's parser
    # removes the indentation of a triple-quoted string that spans lines, so
    # such a string keeps a node of its own and its text as written. Keep any
    # escape not listed in ESCAPES as a node of its own, so it can't make two
    # different strings the same.
    #
    # "a\tb"  ->  "a	b"
    # """a"""  ->  "a"
    # "a$b"  ->  (string_literal "a" (string_interpolation b))
    # "a$(b)"  ->  (string_literal "a" (string_interpolation b))
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        opener, *parts = match.node.children
        pieces = parts.flat_map { |part| string_pieces(part) }
        triple = opener.text == '"""' && pieces.any? { |piece| piece.is_a?(String) && piece.include?("\n") }
        string_node(pieces, triple ? :triple_quoted_string : :string_literal)
      end
    end

    def string_pieces(part)
      case part.type
      when "content" then [part.text]
      when "escape_sequence" then [escape(part.text)]
      else [part]
      end
    end

    # Split text into its characters and escapes, and read each escape.
    def escaped_pieces(text)
      text.scan(/\\u\h{1,4}|\\U\h{1,8}|\\.|[^\\]+/m).map { |piece| piece.start_with?("\\") ? escape(piece) : piece }
    end

    # Return the text that an escape stands for, or a node for the escape if
    # it isn't one of the escapes read here.
    def escape(text)
      if text.match?(/\A\\[uU]\h+\z/)
        value = text[2..].to_i(16)
        return value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? leaf(:escape_sequence, text) : [value].pack("U")
      end

      ESCAPES.fetch(text) { leaf(:escape_sequence, text) }
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals, escapes and interpolations. Join neighbouring text.
    def string_node(pieces, type)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty? && type == :string_literal
      return parts.first if type == :string_literal && parts.one? && parts.first.type == "literal"

      build(type, *parts)
    end
  end
end
