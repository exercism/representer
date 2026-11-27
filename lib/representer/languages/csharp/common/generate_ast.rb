# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that C#'s own parser (Roslyn) gives.
module Representer::Languages::CSharp::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them. Keep `using` and `await`, because `using var x` and
    # `await foreach` differ from `var x` and `foreach` only by them.
    # if (x) { return y; }  ->  (if_statement x (block (return_statement y)))
    strip_tokens "new", "return", "if", "else", "class", "struct", "interface", "record", "enum", "namespace", "var",
                 "for", "foreach", "while", "do", "switch", "break", "continue", "throw", "try", "catch", "finally", "lock",
                 "typeof", "sizeof", "yield", "goto"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # f(a, b);  ->  (invocation_expression f (argument_list a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ";", ",", ".", ":", "?", "=>", '"'

    # Keep these tokens in the nodes listed, because they are the only thing
    # that tells two programs apart there.
    # record struct P and record class P
    # where T : struct and where T : class?
    # int[,] and int[], new[,] and new[], and Dictionary<,> and List<>
    # for (;; i++) and for (i++;;)
    keep_tokens "class", "struct", in: :record_declaration
    keep_tokens "class", "struct", "?", in: :type_parameter_constraint
    keep_tokens ",", in: [:array_rank_specifier, :implicit_array_creation_expression, :type_argument_list]
    keep_tokens ";", in: :for_statement

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a)  ->  a
    unwrap :parenthesized_expression

    # Write each number as its value. A `float` or `double` keeps its suffix,
    # in lower case. A decimal (`1.50m`) keeps its digits, because .NET keeps
    # a decimal's scale, and an integer with a suffix keeps its text.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    # 1E7F  ->  10000000.0f
    numbers_are integer: :integer_literal,
                decimal: :real_literal,
                suffixes: ["f", "d"]

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\0' => "\0",
      '\a' => "\a",
      '\b' => "\b",
      '\f' => "\f",
      '\v' => "\v",
      '\e' => "\e",
      '\\\\' => "\\",
      '\"' => '"',
      "\\'" => "'"
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        add_parameter_node_to_bare_lambda_parameters!
        mark_let_and_join_variables_as_names!
      end
    end

    private
    ### Values ###

    # Turn each regular and verbatim string into its value, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same.
    #
    # "\x41"  ->  "A"
    # "\u0041"  ->  "A"
    # @"a""b"  ->  "a\"b"
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        string_node(match.node.named_children.map { |part| string_piece(part) })
      end
      transform(tree, "(verbatim_string_literal) @string") { |match| literal(match.node.text[2..-2].gsub('""', '"')) }
    end

    # Return a string part's text, or its node if it isn't text, such as the
    # `u8` of a UTF-8 string.
    def string_piece(part)
      case part.type
      when "string_literal_content" then part.text
      when "escape_sequence" then escape(part)
      else part
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for no single character, such as half of a surrogate pair.
    def escape(node)
      code = node.text[1..]
      return ESCAPES.fetch(node.text, node) unless code.match?(/\A(u\h{4}|U\h{8}|x\h{1,4})\z/)

      value = code[1..].to_i(16)
      value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? node : [value].pack("U")
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and escapes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string_literal, *parts)
    end

    ### Names ###

    # Give a lambda's single parameter without brackets a `parameter` node,
    # as Roslyn does, so that spec.rb can list it with the other parameters.
    # x => x * 2 has the parameter x
    def add_parameter_node_to_bare_lambda_parameters!
      transform(tree, "(implicit_parameter) @parameter") do |match|
        build(:parameter, { name: leaf(:identifier, match.node.text) })
      end
    end

    # Mark the variable that a query's `let` or `join` defines as its name, as
    # Roslyn does.
    # let «total» = a + b
    # join «order» in orders on ...
    def mark_let_and_join_variables_as_names!
      captured(tree, "[(let_clause (identifier) @name) (join_clause (identifier) @name)]").each do |name|
        name.field = "name"
      end
    end
  end
end
