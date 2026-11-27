module Representer::Engine
  # Finds every node that a snippet's `remove` removes, wherever it is in the
  # tree, and returns their byte ranges in the source. It doesn't look
  # inside a removed node.
  class FindRemovedNodes
    include Mandate

    initialize_with :rules, :tree

    def call
      found = []
      stack = [[tree, nil]]
      until stack.empty?
        node, parent = stack.pop
        next found << node.span if rules.removes?(node, parent)

        stack.concat(node.children.map { |child| [child, node] })
      end
      found
    end
  end
end
