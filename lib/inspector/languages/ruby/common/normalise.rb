# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
module Inspector::Languages::Ruby::Common
  class Normalise < Inspector::Engine::Normalise
    # Mark each method and attribute with the modifier line above it, and drop the line.
    #
    # e.g. We convert:
    # private
    # attr_reader :foo, :bar
    # def area
    #
    # internally into:
    # attr_reader :foo, :bar (private)
    # def area (private)
    #
    # and strip out the private line.
    #
    # This allows us to reorder the contents of a class/module safely.
    #
    # Note: `private :x` is left as an ordinary call for now.
    attach_to_each_following "private",
                             "protected",
                             "public",
                             "module_function",
        to: ["def {{_}}({{...}})\n{{...}}\nend", "attr_reader {{...}}", "attr_writer {{...}}", "attr_accessor {{...}}"]

    def call
      super.tap do |root|
        attach_visibility_to_the_def_it_wraps!(root)
      end
    end

    private
    # Mark a method defined inside `private`, `protected` or `public` with that modifier.
    #
    # e.g. We convert:
    # private def area
    #   ...
    # end
    #
    # internally into
    # def area (private)
    #   ...
    # end
    #
    # This matches the attach_to_each_following behaviour above.
    def attach_visibility_to_the_def_it_wraps!(root)
      pattern = '(call !receiver method: (identifier /\A(private|protected|public)\z/) arguments: (argument_list (method)))'
      transform(root, pattern) do |match|
        arguments = match.node[:arguments].children
        attach(arguments.first, match.node[:method]) if arguments.one?
      end
    end
  end
end
