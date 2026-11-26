# Ruby's Reorder stage sorts nothing, as the old representer kept the order
# of everything. Update this comment whenever the class changes.
module Representer
  module Languages
    module Ruby
      class Reorder
        include Mandate

        initialize_with :tree

        def call = tree
      end
    end
  end
end
