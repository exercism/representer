# REPRESENTER_DSL.md and WRITING_GENERATE_AST.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, with one form for each value.
module Representer::Languages::Wren::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # if (x) return y  ->  (if_statement x (return_statement y))
    strip_tokens "class", "construct", "for", "in", "if", "return", "var"

    # Strip the brackets and commas, because they are layout.
    # f(a, b)  ->  (call_expression f (argument_list a b))
    strip_tokens "(", ")", "{", "}", "[", "]", ","

    # Strip the quotes of a string and the `%` of an interpolation, because
    # they are layout.
    # "a%(b)"  ->  (string "a" (interpolation b))
    strip_tokens '"', only_in: :string
    strip_tokens "%", only_in: :interpolation

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_expression (binary_expression a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value. Every Wren number is a double, so an
    # integer and a decimal with the same value are the same.
    #
    # 0x1F  ->  31
    # 1.0  ->  1
    # 1e3  ->  1000
    # 1.50  ->  1.5
    numbers_are number: :number

    ESCAPES = {
      '\n' => "\n",
      '\r' => "\r",
      '\t' => "\t",
      '\0' => "\0",
      '\a' => "\a",
      '\b' => "\b",
      '\e' => "\e",
      '\f' => "\f",
      '\v' => "\v",
      '\\\\' => "\\",
      '\"' => '"',
      '\%' => "%"
    }.freeze

    def call
      tree.tap do
        write_strings_as_their_values!
        put_each_setter_parameter_in_a_parameter_list!
      end
    end

    private
    ### Values ###

    # Turn each string into its value, and read its escapes. Keep any other
    # escape as a node of its own, so it can't make two different strings
    # the same. A string with interpolations keeps them, with the text
    # between them as values.
    #
    # """a"""  ->  "a"
    # "A"  ->  "A"
    # "a%(b)"  ->  (string "a" (interpolation b))
    def write_strings_as_their_values!
      transform(tree, "(string) @string") do |match|
        string_node(match.node.named_children.map { |part| string_piece(part) })
      end
      transform(tree, "(raw_string) @string") do |match|
        literal(match.node.text.delete_prefix('"""').delete_suffix('"""'))
      end
    end

    # Return a string part's text, or its node if it isn't text, such as an
    # interpolation.
    def string_piece(part)
      case part.type
      when "string_content" then part.text
      when "escape_sequence" then escape(part)
      else part
      end
    end

    # Return the text that an escape stands for, or the escape's node if it
    # stands for no single character, such as half of a surrogate pair.
    def escape(node)
      code = node.text[1..]
      return ESCAPES.fetch(node.text, node) unless code.match?(/\A(u\h{4}|U\h{8})\z/)

      value = code[1..].to_i(16)
      value.between?(0xD800, 0xDFFF) || value > 0x10FFFF ? node : [value].pack("U")
    end

    # Build a string's value from its pieces: a literal if it is all text, or a
    # string of literals and other nodes. Join neighbouring text.
    def string_node(pieces)
      runs = pieces.chunk_while { |a, b| a.is_a?(String) && b.is_a?(String) }
      parts = runs.map { |run| run.first.is_a?(String) ? literal(run.join) : run.first }
      return literal("") if parts.empty?
      return parts.first if parts.one? && parts.first.type == "literal"

      build(:string, *parts)
    end

    ### Names ###

    # Put a setter's parameter in a parameter list, as a method's parameters
    # are, so that representation/spec.rb can list it with the other parameters.
    # count=(value) { ... }  ->  (setter_definition count = (parameter_list value) ...)
    def put_each_setter_parameter_in_a_parameter_list!
      find_all(tree, "(setter_definition parameter: (identifier) @parameter)").each do |match|
        match.node.replace_child(match[:parameter], build(:parameter_list, leaf(:identifier, match[:parameter].text)))
      end
    end
  end
end
