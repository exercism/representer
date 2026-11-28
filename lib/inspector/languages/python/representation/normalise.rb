# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. These rules
# remove code that makes no difference to a passing solution.
module Inspector::Languages::Python::Representation
  class Normalise < Inspector::Engine::Normalise
    # Drop `if __name__ == "__main__":` blocks, because they only run when
    # the file is run as a script.
    drop 'if __name__ == "__main__": {{...}}'

    # Drop type hints, because Python never checks them. Write a bare
    # annotation as an assignment of `None`.
    # x: int = 1  ->  x = 1
    # x: int  ->  x = None
    # def f(a: int, b: int = 1)  ->  def f(a, b=1)
    rewrite "{{x}}: {{type}} = {{value}}", as: "{{x}} = {{value}}"
    rewrite "{{x}}: {{type}}",             as: "{{x}} = None"
    rewrite "{{x}}: {{type}}",
        as: "{{x}}",
        inside: "def f({{pattern}}): pass"
    rewrite "{{x}}: {{type}} = {{value}}",
        as: "{{x}}={{value}}",
        inside: "def f({{pattern}}): pass"

    BODY = "[(module) (block)] @name".freeze
    STRING = "[(literal) (string) (u_string)]".freeze

    def call
      super.tap do |root|
        drop_return_types!(root)
        drop_docstrings!(root)
        drop_print_statements!(root)
        write_empty_bodies_as_pass!(root)
      end
    end

    private
    # Drop the return type of each function, because Python never checks it.
    # def f() -> int:  ->  def f():
    def drop_return_types!(root)
      find_all(root, "(function_definition return_type: (_) @type)").each do |match|
        match.node.children.reject! { |child| child.equal?(match[:type]) || child.type == "->" }
      end
    end

    # Drop the docstring at the start of each module, class and function.
    #
    # e.g. We convert:
    # def area(width):
    #     """Returns the area."""
    #     return width * width
    #
    # internally into:
    # def area(width):
    #     return width * width
    def drop_docstrings!(root)
      bodies = [root, *captured(root, "[(function_definition body: (_) @name) (class_definition body: (_) @name)]")]
      bodies.each { |body| body.children.shift if body.children.any? && pattern(STRING).match(body.children.first) }
    end

    # Drop each statement that only calls `print`, because the tests don't
    # read what a solution prints.
    def drop_print_statements!(root)
      print_call = pattern('(call function: (identifier "print"))')
      captured(root, BODY).each { |body| body.children.reject! { |statement| print_call.match(statement) } }
    end

    # Write each body that the steps above left empty as `pass`, so that a
    # function with only a docstring gets the same tree as `def f(): pass`.
    def write_empty_bodies_as_pass!(root)
      captured(root, BODY).each { |body| body.children << build(:pass_statement) if body.children.empty? }
    end
  end
end
