# Ruby's Normalise stage gives each method the visibility it has, wherever
# it moves when Reorder sorts a class's or a module's body:
#
# - A bare `private`, `protected` or `public` line goes, and each method
#   and each `attr_reader`, `attr_writer` and `attr_accessor` after it
#   gets that visibility as a mark, up to the next of these lines or the
#   end of the body.
# - `private def x ... end` gets the tree of the method `x` marked
#   private, so it is the same as `def x ... end` after a `private` line.
#   The same goes for `protected def` and `public def`.
# - `private :x` stays as it is, as an ordinary call.
#
# Update this list whenever the class changes.
module Representer
  module Languages
    module Ruby
      class Normalise < Engine::Normalise
        attach_to_each_following "private", "protected", "public",
          to: ["def {{name}}\nend", "attr_reader {{names}}", "attr_writer {{names}}", "attr_accessor {{names}}"]

        def call = visibility_before_def(super)

        private
        # `private def x ... end` calls `private` with the method. The
        # method takes the place of the call, with `private` as its mark.
        def visibility_before_def(root)
          pattern = '(call !receiver method: (identifier /\A(private|protected|public)\z/) arguments: (argument_list (method)))'
          transform(root, pattern) do |match|
            arguments = match.node[:arguments].children
            attach(arguments.first, match.node[:method]) if arguments.one?
          end
        end
      end
    end
  end
end
