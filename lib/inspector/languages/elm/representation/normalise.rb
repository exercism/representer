# docs/representation.md defines the verbs in this file, and
# docs/writing-generate-ast.md defines the helpers.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
module Inspector::Languages::Elm::Representation
  class Normalise < Inspector::Engine::Normalise
    def call
      super.tap do |root|
        drop_the_list_of_what_the_module_exposes!(root)
      end
    end

    private
    # Drop the list of what the module exposes, because every solution
    # exposes what the tests use. The engine has already dropped the
    # imports, with their own lists.
    # module Leap exposing (isLeapYear)  ->  module Leap
    def drop_the_list_of_what_the_module_exposes!(root)
      drop(root, "(exposing_list)")
    end
  end
end
