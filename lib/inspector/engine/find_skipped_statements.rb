module Inspector::Engine
  # Finds the statements at the top of a file that a snippet's skip_at_top
  # skips, and returns their byte ranges in the source.
  #
  # It looks at the file's top-level statements in order. It skips each one
  # whose source starts with one of the words, and each node that `remove`
  # removes. It stops at the first other statement, so the same words
  # further down stay. Punctuation between the statements (such as Raku's
  # `;`) goes too, but a keyword token (such as Zig's `pub`) is code.
  #
  # For a container (see Snippet.containers), it skips only the header line,
  # and goes on with the statements inside. With containers: false, it stops
  # at a container instead.
  class FindSkippedStatements
    include Mandate

    initialize_with :rules, :tree, :source, containers: true

    def call = skip(tree.children, tree)

    private
    def skip(nodes, parent)
      skipped = []
      nodes.each do |node|
        next skipped << node.span if rules.removes?(node, parent) || (!node.named? && !node.type.match?(/\w/))
        return skipped unless rules.starts_with_skipped_word?(source.byteslice(node.span))
        return skipped if rules.container?(node) && !containers

        body = rules.container?(node) && first_on_a_later_line(node)
        next skipped << node.span unless body

        first, holder = body
        siblings = holder.children
        return skipped + [node.span.begin...first.span.begin] + closing(holder, first) +
               skip(siblings.drop(siblings.index { |child| child.equal?(first) }), holder)
      end
      skipped
    end

    # The container's closing bracket (such as the `}` of `namespace x {`),
    # which goes with its header, so it doesn't dangle at the end.
    def closing(holder, first)
      last = holder.children.last
      last && !last.named? && !last.equal?(first) ? [last.span] : []
    end

    # The first node inside the container that starts on a later line than
    # the container, with its parent. It looks inside a last child that
    # starts on the first line, such as the braces of `namespace App {`.
    def first_on_a_later_line(node)
      line_end = source.index("\n", source.byteslice(0, node.span.begin).length)
      return nil unless line_end

      line_end = source[0, line_end].bytesize
      parent = node
      loop do
        child = parent.children.find { |candidate| candidate.span.begin > line_end }
        return [child, parent] if child

        parent = parent.children.last
        return nil unless parent && parent.span.end > line_end
      end
    end
  end
end
