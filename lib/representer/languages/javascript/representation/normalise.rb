# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
module Representer::Languages::JavaScript::Representation
  class Normalise < Representer::Engine::Normalise
    REQUIRE = '(variable_declarator value: (call_expression function: (identifier "require") arguments: (arguments (literal))))'.freeze

    MODULE_EXPORTS = '(expression_statement (assignment_expression left: (member_expression object: (identifier "module") ' \
                     'property: (property_identifier "exports")) right: (object) @list))'.freeze

    def call
      super.tap do |root|
        drop_empty_statements!(root)
        drop_require_declarations!(root)
        drop_module_exports_lists!(root)
      end
    end

    private
    # Drop each empty statement. Keep the ones in a field, such as the
    # missing parts of a `for`, because `for (;; i++)` and `for (i++;;)` are
    # different loops.
    # let x = 1;;  ->  let x = 1;
    def drop_empty_statements!(root)
      drop_children!(root) { |child| child.type == "empty_statement" && child.field.nil? }
    end

    # Drop each declaration that only loads modules with `require`, as an
    # import. A code pattern would also match a declaration that declares
    # other variables too, so this step checks every variable.
    # const fs = require("fs");  ->  (nothing)
    def drop_require_declarations!(root)
      requires = find_all(root, REQUIRE).map(&:node)
      drop_children!(root) do |child|
        declarators = child.named_children.select { |node| node.type == "variable_declarator" }
        declarators.any? && declarators.all? { |declarator| requires.any? { |node| node.equal?(declarator) } }
      end
    end

    # Drop a `module.exports` that only lists names, as an export list. A
    # code pattern would also match one that defines a property, so this step
    # checks that every property is a name.
    # module.exports = { a, b };  ->  (nothing)
    def drop_module_exports_lists!(root)
      lists = find_all(root, MODULE_EXPORTS).select do |match|
        match[:list].named_children.all? { |child| child.type == "shorthand_property_identifier" }
      end
      drop_children!(root) { |child| lists.any? { |match| match.node.equal?(child) } }
    end

    def drop_children!(root, &drop)
      each_node(root) { |node, _| node.children.reject!(&drop) }
    end
  end
end
