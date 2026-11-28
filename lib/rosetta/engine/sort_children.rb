module Rosetta::Engine
  # Sorts the children of every node of the given types, for a Reorder
  # stage's `sort` verb:
  #
  # - It sorts the children by their code, written with every renamed name
  #   as `_` (see Serialize), so two solutions that only name things
  #   differently get the same order.
  # - Two children with the same code keep the order they had.
  # - It sorts the inner nodes before the outer ones, so the order of a
  #   node's children never depends on an order that changes later.
  #
  # The order of these children must make no difference to the solution
  # working, so the types are containers of definitions or entries, such
  # as a class's body or a map. A block of statements runs in order, so it
  # is never one of them.
  class SortChildren
    include Mandate
    include TreeHelpers

    initialize_with :tree, :types

    def call
      types = self.types.map(&:to_s)
      nodes = []
      each_node(tree) { |node, _| nodes << node if types.include?(node.type) }
      nodes.reverse_each { |node| node.children = sorted(node.children) }
      tree
    end

    private
    def sorted(nodes) = nodes.sort_by.with_index { |node, index| [key(node), index] }

    # Serialize writes a node with its children, so a leaf goes inside a
    # node to keep its text.
    def key(node) = Serialize.(Node.new("key", [node]), blank: true)
  end
end
