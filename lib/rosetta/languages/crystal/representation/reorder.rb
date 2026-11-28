# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so reordering only exists to group students who list things in a different order.
module Rosetta::Languages::Crystal::Representation
  class Reorder < Rosetta::Engine::Reorder
    def call
      super.tap do |root|
        reorder_the_methods_in_each_body!(root)
      end
    end

    private
    # Reorder the methods inside classes, modules and structs, and at the top
    # of the file. Leave the other code where it is, and put the methods in
    # the places where methods were.
    # def a; end; def b; end == def b; end; def a; end
    def reorder_the_methods_in_each_body!(root)
      bodies = captured(root, "[(class_def body: (_) @name) (module_def body: (_) @name) (struct_def body: (_) @name)]")
      [root, *bodies].reverse_each { |body| body.children = with_methods_sorted(body.children) }
    end

    def with_methods_sorted(children)
      places = children.each_index.select { |index| method?(children[index]) }
      methods = places.map { |index| children[index] }.sort_by.with_index { |method, index| [key(method), index] }
      children.dup.tap { |sorted| places.zip(methods) { |place, method| sorted[place] = method } }
    end

    # Treat `private def` as a method too.
    def method?(node)
      node.type == "method_def" || (node.type == "visibility_modifier" && node.children.any? { |child| child.type == "method_def" })
    end

    # Sort by the code, with every renamed name left blank, so two solutions
    # that only name things differently get the same order.
    def key(node) = Rosetta::Engine::Serialize.(Rosetta::Engine::Node.new("key", [node]), blank: true)
  end
end
