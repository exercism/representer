# docs/writing-generate-ast.md defines the helpers in this file.
# This stage runs only on the analysis's tree. A class or module can define
# a method on itself in several ways, and the tests call each one the same
# way, so this stage writes each of them as `def self.name`. Each rule can
# then find the method with one pattern.
module Inspector::Languages::Ruby::Analysis
  class Normalise < Inspector::Engine::Normalise
    def call
      super.tap do |root|
        write_methods_on_the_class_name_on_self!(root)
        move_methods_out_of_class_self!(root)
        write_module_functions_on_self!(root)
      end
    end

    private
    # Write a method defined on the name of the class around it as a method
    # on self.
    # class TwoFer; def TwoFer.two_fer; end; end  ->  class TwoFer; def self.two_fer; end; end
    def write_methods_on_the_class_name_on_self!(root)
      find_all(root, "[(class name: (constant) @name) (module name: (constant) @name)]").each do |definition|
        each_node(definition.node) do |node, _|
          object = node[:object]
          next unless node.type == "singleton_method" && object.type == "constant" && object.text == definition[:name].text

          node.replace_child(object, leaf(:self, "self"))
        end
      end
    end

    # Move each method out of `class << self`, as a method on self. Keep any
    # other code in `class << self`.
    # class << self; def two_fer; end; end  ->  def self.two_fer; end
    def move_methods_out_of_class_self!(root)
      each_node(root) do |node, _|
        node.children = node.children.flat_map { |child| class_self?(child) ? split_class_self(child) : [child] }
      end
    end

    def class_self?(node) = node.type == "singleton_class" && node[:value]&.type == "self" && node[:body]

    def split_class_self(singleton)
      body = singleton[:body]
      methods, others = body.children.partition { |statement| statement.type == "method" }
      body.children = others
      [*([singleton] if others.any?), *methods.map { |method| on_self(method) }]
    end

    # Write each method marked with `module_function`, or named in a
    # `module_function :name` call, as a method on self. The Normalise stage
    # in `common/` has already marked the methods after a `module_function`
    # line.
    #
    # module_function
    # def two_fer; end  ->  def self.two_fer; end
    def write_module_functions_on_self!(root)
      each_node(root) do |node, _|
        named = module_function_names(node)
        node.children.each do |child|
          on_self(child) if child.type == "method" && (module_function?(child) || named.include?(child[:name].text))
        end
      end
    end

    def module_function?(method) = method.children.any? { |child| module_function_mark?(child) }
    def module_function_mark?(node) = node.field.nil? && node.type == "identifier" && node.text == "module_function"

    # The names given to `module_function :name` calls among the node's
    # children.
    def module_function_names(node)
      calls = node.children.select { |child| child.type == "call" && child[:method]&.text == "module_function" && !child[:receiver] }
      symbols = calls.flat_map { |call| call[:arguments]&.children.to_a }.select { |name| name.type == "simple_symbol" }
      symbols.map { |name| name.text.delete_prefix(":") }
    end

    # Turn a method into a method on self, without its `module_function` mark.
    def on_self(method)
      method.type = "singleton_method"
      method.children.reject! { |child| module_function_mark?(child) }
      method.children.unshift(leaf(:self, "self", field: :object))
      method
    end
  end
end
