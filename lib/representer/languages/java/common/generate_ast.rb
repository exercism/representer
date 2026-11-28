# docs/dsl.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# the simpler tree that Java's own parser (javac) gives.
module Representer::Languages::Java::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) { return y; }  ->  (if_statement x (block (return_statement y)))
    strip_tokens "if", "else", "for", "while", "do", "return", "new", "class", "enum", "record", "interface", "switch",
                 "throw", "try", "catch", "finally", "break", "continue", "assert"

    # Strip the brackets, commas and other punctuation, because they are layout.
    # f(a, b);  ->  (method_invocation f (argument_list a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ";", ",", '"'

    # Keep these tokens in the nodes listed, because they are the only thing
    # that tells two programs apart there.
    # int[] and int[][]
    # for (;; i++) and for (i++;;)
    keep_tokens "[", "]", in: :dimensions
    keep_tokens ";", in: :for_statement

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b)  ->  a + b
    unwrap :parenthesized_expression

    # Write each number as its value. A leading 0 means octal. A `float` or
    # `double` keeps its suffix, in lower case.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 017  ->  15
    # 1.50  ->  1.5
    # 1.5e3F  ->  1500.0f
    numbers_are integer: [:decimal_integer_literal, :hex_integer_literal, :octal_integer_literal, :binary_integer_literal],
                decimal: :decimal_floating_point_literal,
                prefixes: { "0x" => 16, "0b" => 2, "0" => 8 },
                suffixes: ["f", "d"]

    ESCAPES = {
      '\n' => "\n",
      '\t' => "\t",
      '\r' => "\r",
      '\b' => "\b",
      '\f' => "\f",
      '\s' => " ",
      '\\\\' => "\\",
      "\\'" => "'",
      '\"' => '"'
    }.freeze

    def call
      tree.tap do
        write_long_integers_as_their_values!
        write_strings_as_their_values!
        drop_brackets_around_a_single_lambda_parameter!
        write_each_variable_as_a_declaration_of_its_own!
        drop_the_empty_semicolon_after_enum_constants!
      end
    end

    private
    ### Values ###

    # Write each `long` integer as its value too, and keep its `L`.
    # 1_000L  ->  1000L
    # 0x10l  ->  16L
    def write_long_integers_as_their_values!
      numbers = self.class.numbers
      each_node(tree) do |node, _|
        next unless numbers[:integer].include?(node.type) && node.text.match?(/[lL]\z/)

        value = Representer::Engine::Numbers.integer(node.text[0...-1], prefixes: numbers[:prefixes])
        node.text = "#{value}L" if value
      end
    end

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a node of its own, so it can't make two different strings the
    # same. A text block keeps its text.
    #
    # "A"  ->  "A"
    # "\101"  ->  "A"
    def write_strings_as_their_values!
      transform(tree, "(string_literal) @string") do |match|
        parts = match.node.children.reject { |child| !child.named? && child.type == '"' }
        next nil unless parts.all? { |part| ["string_fragment", "escape_sequence"].include?(part.type) }

        string_node(parts.map { |part| part.type == "escape_sequence" ? escape(part) : part.text })
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for no single character, such as half of a surrogate pair.
    def escape(node)
      code = node.text[1..]
      case code
      when /\Au+(\h{4})\z/
        value = Regexp.last_match(1).to_i(16)
        value.between?(0xD800, 0xDFFF) ? node : [value].pack("U")
      when /\A[0-3]?[0-7]{1,2}\z/ then code.to_i(8).chr(Encoding::UTF_8)
      else ESCAPES.fetch(node.text, node)
      end
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

    ### Lambdas and declarations ###

    # Drop the brackets around a lambda's single parameter without a type, as
    # javac does.
    # (x) -> x  ->  x -> x
    def drop_brackets_around_a_single_lambda_parameter!
      pattern = "(lambda_expression parameters: (inferred_parameters (identifier) @parameter) @parameters)"
      transform(tree, pattern) do |match|
        next nil unless match[:parameters].named_children.one?

        match.node.replace_child(match[:parameters], match[:parameter])
        match.node
      end
    end

    # Write each variable of a declaration as a declaration of its own, as
    # javac does. Leave the declarations in a `for` loop's header alone.
    # int a, b = 1;  ->  int a; int b = 1;
    def write_each_variable_as_a_declaration_of_its_own!
      each_node(tree) do |node, _|
        node.children.replace(node.children.flat_map { |child| split_declaration(child) }) unless node.type == "for_statement"
      end
    end

    def split_declaration(declaration)
      return [declaration] unless ["local_variable_declaration", "field_declaration"].include?(declaration.type)

      declarators = declaration.children.select { |child| child.type == "variable_declarator" }
      return [declaration] unless declarators.size > 1

      declarators.map do |declarator|
        copy(declaration).tap do |own|
          own.children.reject! { |child| child.type == "variable_declarator" }
          own.children << copy(declarator)
        end
      end
    end

    # Drop the `;` after an enum's constants when nothing follows it, because
    # javac gives no node for it.
    # enum Color { RED, GREEN; }  ->  enum Color { RED, GREEN }
    def drop_the_empty_semicolon_after_enum_constants!
      each_node(tree) do |node, _|
        node.children.reject! { |child| child.type == "enum_body_declarations" && child.named_children.empty? }
      end
    end
  end
end
