# Ruby's Reorder stage sorts nothing, because the old representer kept the
# order of everything.
#
# Update this comment whenever the class changes.
module Representer
  module Languages
    module Ruby
      class Reorder
        extend Engine::ReorderStage
      end
    end
  end
end
