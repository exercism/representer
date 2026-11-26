# Ruby's Normalise stage drops `require` and `require_relative` calls. They
# only make code available, and a solution that passes its tests has
# required everything it uses.
#
# The old representer made no other changes of its own, so this stage makes
# none either. Update this list whenever the class changes.
module Representer
  module Languages
    module Ruby
      class Normalise
        include Mandate
        include Engine::TreeHelpers

        initialize_with :tree

        def call
          drop(tree, "(call !receiver method: (identifier /\\Arequire(_relative)?\\z/) arguments: (argument_list (literal)))")
        end
      end
    end
  end
end
