module Inspector::Engine
  # Turns a line that changes the definitions after it into a mark on each
  # of them, for a Normalise stage's `attach_to_each_following` verb, so
  # each definition keeps its meaning when a Reorder stage sorts them.
  # Ruby's `private` is one such line:
  #
  # - Each line that matches one of the line patterns goes. A line is a
  #   child with no field name, so a call's `private` in `private def x`
  #   isn't one.
  # - Every definition after it in the same node gets a copy of the line
  #   as its last child, up to the next of these lines or the end of the
  #   node. A definition is a child that matches one of the definition
  #   patterns.
  # - Other code between the definitions gets no mark.
  class AttachToEachFollowing
    include Mandate
    include TreeHelpers

    initialize_with :tree, :lines, :definitions

    def call
      containers = []
      each_node(tree) { |node, _| containers << node if node.children.any? { |child| line?(child) } }
      containers.each { |node| node.children = mark_each(node.children) }
      tree
    end

    private
    def mark_each(children)
      mark = nil
      children.reject do |child|
        if line?(child)
          mark = child
          true
        else
          attach(child, copy(mark)) if mark && definition?(child)
          false
        end
      end
    end

    # A line stands on its own, so it has no field name. This keeps the
    # `private` of `private def x` from counting as a line.
    def line?(node) = node.field.nil? && lines.any? { |pattern| pattern(pattern).match(node) }
    def definition?(node) = definitions.any? { |pattern| pattern(pattern).match(node) }
  end
end
