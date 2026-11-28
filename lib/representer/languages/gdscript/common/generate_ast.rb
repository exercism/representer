# docs/common.md and docs/writing-generate-ast.md define the declarations and
# helpers in this file.
# Tree-sitter's tree keeps every token and spelling, but a mentor would give
# the same feedback however a solution is written. So this stage turns it into
# a simpler tree, closer to the one that Godot's own GDScript parser gives.
module Representer::Languages::GDScript::Common
  class GenerateAST < Representer::Engine::GenerateAST
    # Strip the keywords that sit in a fixed place, because the node types
    # already show them.
    # func f(): return 1  ->  (function_definition (name f) (parameters) : (body (return_statement 1)))
    strip_tokens "func", "return", "var", "extends", "class", "pass", "break", "continue", "if", "elif", "else",
                 "for", "while", "match"

    # Strip the brackets, commas and semicolons, because they are layout.
    # f(a, b)  ->  (call f (arguments a b))
    strip_tokens "(", ")", "[", "]", "{", "}", ",", ";"

    # Unwrap brackets that only group, because the tree's shape shows the grouping.
    # (a + b) * c  ->  (binary_operator (binary_operator a + b) * c)
    unwrap :parenthesized_expression

    # Write each number as its value.
    #
    # 1_000  ->  1000
    # 0x1F  ->  31
    # 1.50  ->  1.5
    numbers_are integer: :integer,
                decimal: :float,
                prefixes: { "0x" => 16, "0b" => 2 }

    PARAMETERS = "[(default_parameter) (typed_parameter) (typed_default_parameter)] @name".freeze

    def call
      tree.tap do
        drop_line_continuations!
        write_strings_as_their_values!
        mark_the_names_of_parameters!
      end
    end

    private
    # Drop the backslashes that continue a line, because they are layout.
    def drop_line_continuations!
      drop(tree, "(line_continuation)")
    end

    # Turn each string in quotes into its value. Read only an escaped quote,
    # and keep every other escape as it is written. Keep a triple-quoted
    # string as a node of its own.
    #
    # 'a'  ->  "a"
    # 'it\'s'  ->  "it's"
    # """a"""  ->  (multiline_string "a")
    def write_strings_as_their_values!
      transform(tree, "(string) @string") { |match| string_value(match.node.text) }
    end

    # Return a string's value, or nil for a string with a prefix, such as a
    # raw string (`r"a"`).
    def string_value(text)
      quote = text[0]
      return nil unless ['"', "'"].include?(quote)
      return build(:multiline_string, literal(text[3...-3])) if text.start_with?(quote * 3)

      literal(text[1...-1].gsub(/\\(.)/m) { Regexp.last_match(1) == quote ? quote : Regexp.last_match(0) })
    end

    # Put the name of each parameter with a default or a type in the field
    # `name`, so that representation/spec.rb can list it without its default.
    # func f(«a» = b, «c»: int):
    def mark_the_names_of_parameters!
      captured(tree, PARAMETERS).each { |parameter| parameter.children.first.field = "name" }
    end
  end
end
