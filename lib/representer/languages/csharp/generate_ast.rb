# REPRESENTER_DSL.md defines the helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that C#'s own parser (Roslyn) gives, as the old representer
# used.
module Representer::Languages::CSharp
  class GenerateAST < Representer::Engine::GenerateAST
    # Drop these tokens from every node, because the node types already show
    # them. They are keywords and punctuation that sit in a fixed place.
    #
    # e.g. We convert:
    # if (x) { return y; }
    #
    # internally into:
    # (if_statement x (block (return_statement y)))
    #
    # `using` and `await` stay, because `using var x` and `await foreach`
    # differ from `var x` and `foreach` only by them.
    TOKENS = %w[
      ( ) { } [ ] ; , . : ? => "
      new return if else class struct interface record enum namespace var for foreach while do switch
      break continue throw try catch finally lock typeof sizeof yield goto
    ].freeze

    # Keep these tokens in the nodes listed, because they are the only thing
    # that tells two programs apart there.
    #
    # e.g. `record struct` and `record class`, `where T : class` and
    # `where T : struct?`, `int[,]` and `int[]`, `new[,]` and `new[]`,
    # `Dictionary<,>` and `List<>`, and `for (;; i++)` and `for (i++;;)`.
    TOKENS_KEPT_IN = {
      "record_declaration" => %w[class struct], "type_parameter_constraint" => %w[class struct ?],
      "array_rank_specifier" => %w[,], "implicit_array_creation_expression" => %w[,],
      "type_argument_list" => %w[,], "for_statement" => %w[;]
    }.freeze

    # The escapes that a string reads, and the text each one stands for.
    ESCAPES = {
      "n" => "\n", "t" => "\t", "r" => "\r", "0" => "\0", "a" => "\a", "b" => "\b", "f" => "\f",
      "v" => "\v", "e" => "\e", "\\" => "\\", '"' => '"', "'" => "'"
    }.freeze

    Numbers = Representer::Engine::Numbers

    def call
      tree.tap do
        drop_comments!
        write_strings_as_their_values!
        write_numbers_as_their_values!
        add_parameter_node_to_bare_lambda_parameters!
        mark_let_and_join_variables_as_names!
        drop_tokens_that_the_node_types_already_show!
        unwrap_brackets_that_only_group!
      end
    end

    private
    ### Comments, brackets and tokens ###

    # Drop comments.
    def drop_comments!
      drop(tree, "(comment)")
    end

    # Drop the tokens listed in TOKENS from every node, apart from the node
    # types listed in TOKENS_KEPT_IN.
    def drop_tokens_that_the_node_types_already_show!
      drop_tokens(tree, everywhere: TOKENS, kept_in: TOKENS_KEPT_IN)
    end

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (1 + 2) * 3 keeps its shape, and (a) == a
    def unwrap_brackets_that_only_group!
      unwrap(tree, "(parenthesized_expression)")
    end

    ### Values ###

    # Turn each regular and verbatim string into its value, and read its
    # escapes. Keep any other escape as a node of its own, so it can't make
    # two different strings the same.
    #
    # "\x41" == "A" == "A"
    # @"a""b" == "a\"b"
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
      return ESCAPES.fetch(code, node) unless code.match?(/\A(u\h{4}|U\h{8}|x\h{1,4})\z/)

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

    # Write each number as its value. A decimal (`1.50m`) keeps its digits,
    # because .NET keeps a decimal's scale, and an integer with a suffix keeps
    # its text.
    #
    # 1_000 == 1000
    # 0x1F == 0b11111 == 31
    # 1.50 == 1.5
    # 1e7 == 1E7 == 10000000.0
    def write_numbers_as_their_values!
      each_node(tree) do |node, _|
        next unless node.named? && node.leaf?

        case node.type
        when "integer_literal" then node.text = Numbers.integer(node.text)&.to_s || node.text
        when "real_literal" then node.text = real(node.text) || node.text
        end
      end
    end

    def real(text)
      digits, suffix = text.match(/\A(.*?)([fFdD])?\z/).captures
      value = Numbers.decimal(digits)
      value && "#{Numbers.write_decimal(value)}#{suffix&.downcase}"
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
