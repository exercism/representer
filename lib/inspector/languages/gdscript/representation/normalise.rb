# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. These rules
# remove code that makes no difference to a passing solution, and give one
# form to spellings that mean the same thing.
module Inspector::Languages::GDScript::Representation
  class Normalise < Inspector::Engine::Normalise
    # Write the symbol operators as words, because GDScript reads both the same.
    # a && b  ->  a and b
    # a || b  ->  a or b
    # !a  ->  not a
    rewrite "{{a}} && {{b}}", as: "{{a}} and {{b}}"
    rewrite "{{a}} || {{b}}", as: "{{a}} or {{b}}"
    rewrite "!{{a}}",         as: "not {{a}}"

    TYPED = "[(typed_parameter) (typed_default_parameter) (variable_statement) (const_statement) (for_statement) " \
            "(function_definition) (lambda)] @name".freeze

    TYPE_HINTS = ["type", "inferred_type"].freeze

    STRINGS = ["literal", "multiline_string", "string"].freeze

    def call
      super.tap do |root|
        drop_docstrings!(root)
        drop_type_hints!(root)
      end
    end

    private
    # Drop each statement that is only a string, because it is never run.
    #
    # e.g. We convert:
    # func area(width):
    #     """Returns the area."""
    #     return width * width
    #
    # internally into:
    # func area(width):
    #     return width * width
    def drop_docstrings!(root)
      each_node(root) { |node, _| node.children.reject! { |child| string_statement?(child) } }
    end

    def string_statement?(node)
      node.type == "expression_statement" && node.children.size == 1 && STRINGS.include?(node.children.first.type)
    end

    # Drop type hints, because a solution that passes its tests runs the same
    # without them. Write `:=` as `=`.
    # var x: int = 1  ->  var x = 1
    # var x := 1  ->  var x = 1
    # func f(a: int, b := 1) -> int:  ->  func f(a, b = 1):
    # for i: int in xs:  ->  for i in xs:
    def drop_type_hints!(root)
      transform(root, TYPED) { |match| without_type_hint(match.node) }
    end

    # Return the node without its type hint, and the `:` or `->` before it. A
    # typed parameter becomes its name, and a typed parameter with a default
    # becomes a parameter with a default. Return nil if the node has no type
    # hint.
    def without_type_hint(node)
      index = node.children.index { |child| ["type", "return_type"].include?(child.field) && TYPE_HINTS.include?(child.type) }
      return nil unless index

      if node.children[index].type == "inferred_type"
        node.children[index] = token("=")
      else
        node.children.delete_at(index)
        node.children.delete_at(index - 1) if [":", "->"].include?(node.children[index - 1].type)
      end
      return node.children.first if node.type == "typed_parameter"

      node.type = "default_parameter" if node.type == "typed_default_parameter"
      node
    end
  end
end
