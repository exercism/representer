# REPRESENTER_DSL.md defines the verbs and helpers in this file.
module Representer::Languages::Ruby
  class Normalise < Representer::Engine::Normalise
    # A bare `private`, `protected` or `public` line changes every method
    # after it, so the line goes and each method and `attr_*` after it gets
    # a copy of the line as a mark. Each method then keeps its visibility
    # when Reorder sorts the body. `private :x` stays as it is, as an
    # ordinary call.
    attach_to_each_following "private", "protected", "public",
      to: ["def {{name}}\nend", "attr_reader {{names}}", "attr_writer {{names}}", "attr_accessor {{names}}"]

    def call = visibility_before_def(super)

    private
    # `private def x ... end` calls `private` with the method, so the method
    # takes the place of the call, with `private` as its mark. It is then
    # the same as `def x ... end` after a `private` line. The same goes for
    # `protected def` and `public def`.
    def visibility_before_def(root)
      pattern = '(call !receiver method: (identifier /\A(private|protected|public)\z/) arguments: (argument_list (method)))'
      transform(root, pattern) do |match|
        arguments = match.node[:arguments].children
        attach(arguments.first, match.node[:method]) if arguments.one?
      end
    end
  end
end
