module Representer::Engine
  # Moves code that belongs to the definition after it into that
  # definition, for a Normalise stage's `attach_to_next` verb, so the two
  # move together when a Reorder stage sorts the definitions:
  #
  # - Each statement that matches one of the patterns leaves its place
  #   and becomes the last child of the next statement, such as Elixir's
  #   `@spec` moving into the function after it. A statement is a child
  #   with no field name.
  # - If several of these statements come one after the other, they all
  #   move into the next statement, in their order.
  # - If no statement comes after them, or the next one is a leaf (which
  #   can't hold children), they stay where they are.
  class AttachToNext
    include Mandate
    include TreeHelpers

    initialize_with :tree, :patterns

    def call
      containers = []
      each_node(tree) { |node, _| containers << node if node.children.any? { |child| attached?(child) } }
      containers.each { |node| node.children = attach_each(node.children) }
      tree
    end

    private
    def attach_each(children)
      waiting = []
      kept = children.each_with_object([]) do |child, result|
        if attached?(child)
          waiting << child
        elsif waiting.any? && !child.leaf?
          result << attach(child, *waiting)
          waiting = []
        else
          result.concat(waiting) << child
          waiting = []
        end
      end
      kept.concat(waiting)
    end

    # A statement stands on its own, so it has no field name.
    def attached?(node) = node.field.nil? && patterns.any? { |pattern| pattern(pattern).match(node) }
  end
end
