module Rosetta::Engine
  # Gives the first item of each node of the types the field name `head`
  # (see GenerateAST.lists_are). A code pattern then matches that item only
  # as the first item, so Clojure's `(require {{...}})` matches
  # `(require 'clojure.set)`, and doesn't match `(list 1 require 2)`.
  class LabelListHeads
    include Mandate
    include TreeHelpers

    initialize_with :tree, :types

    def call
      return tree if types.empty?

      each_node(tree) do |node, _|
        node.named_children.first&.field = "head" if node.named? && types.include?(node.type)
      end
      tree
    end
  end
end
