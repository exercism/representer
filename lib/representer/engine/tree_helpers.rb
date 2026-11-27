module Representer
  module Engine
    # Operations on a syntax tree, for the stage classes of a staged language
    # (see StagedLanguage). Each class includes this module, and calls these
    # methods in its own order.
    #
    # Methods that take a pattern accept the pattern syntax in
    # Engine::Pattern, or a CodePattern, and templates use the syntax in
    # Engine::Template.
    # A match is a Language::Match: match.node is the matched node, and
    # match[:name] a capture.
    #
    # Each method visits a node once, so a rule can't match its own output
    # and loop. A method that can replace the root returns the new root.
    module TreeHelpers
      PATTERNS = {} # rubocop:disable Style/MutableConstant
      private_constant :PATTERNS

      ### Walking and finding ###

      # Calls the block with every node and its parent, parents before
      # children, in source order. The root's parent is nil. The block may
      # change a node's children, and the walk then visits the new ones.
      def each_node(root)
        stack = [[root, nil]]
        until stack.empty?
          node, parent = stack.pop
          yield node, parent
          node.children.reverse_each { |child| stack << [child, node] }
        end
      end

      # Every match of the pattern, in source order.
      def find_all(root, pattern_source)
        pattern = pattern(pattern_source)
        matches = []
        each_node(root) do |node, _|
          next unless Engine.could_match?(pattern, node.type)

          captures = pattern.match(node)
          matches << Language::Match.new(node, captures) if captures
        end
        matches
      end

      # Every node captured as `name` by any match of the pattern, with list
      # captures (from `pattern*`) flattened.
      def captured(root, pattern_source, name = :name)
        find_all(root, pattern_source).flat_map { |match| Array(match[name]) }
      end

      ### Changing the tree ###

      # Replaces each node that matches the pattern, from the leaves up, so
      # the block sees children that are already transformed. Give a
      # template, or a block that returns the replacement (or the matched
      # node, changed in place, or nil to leave it). Returns the root.
      def transform(root, pattern_source, template = nil, &block)
        pattern = pattern(pattern_source)
        block ||= ->(match) { Template.new(template).build(match.captures) }
        visited = []
        each_node(root) { |node, parent| visited << [node, parent] }
        visited.reverse_each do |node, parent|
          next unless Engine.could_match?(pattern, node.type)

          captures = pattern.match(node)
          replacement = captures && block.(Language::Match.new(node, captures))
          next if replacement.nil? || replacement.equal?(node)
          return replacement if parent.nil?

          parent.replace_child(node, replacement)
        end
        root
      end

      # Removes every node that matches the pattern, with its children.
      def drop(root, pattern_source)
        pattern = pattern(pattern_source)
        each_node(root) do |node, _|
          node.children.reject! { |child| Engine.could_match?(pattern, child.type) && pattern.match(child) }
        end
        root
      end

      # Removes anonymous tokens: the tokens in `everywhere` from every node,
      # apart from the node types in `kept_in`, and the tokens in `only_in`
      # from those node types. Both map a node type to a list of tokens.
      def drop_tokens(root, everywhere: [], only_in: {}, kept_in: {})
        everywhere = everywhere.to_set
        each_node(root) do |node, _|
          kept = kept_in.fetch(node.type, [])
          extra = only_in.fetch(node.type, [])
          node.children.reject! do |child|
            !child.named? && ((everywhere.include?(child.type) && !kept.include?(child.type)) || extra.include?(child.type))
          end
        end
        root
      end

      # Replaces each node that matches the pattern and has exactly one
      # named child with that child, for brackets that only group.
      def unwrap(root, pattern_source)
        transform(root, pattern_source) do |match|
          named = match.node.named_children
          named.first if named.one?
        end
      end

      # Gives nodes of one type another type: retype(root, "do_block" => "block").
      def retype(root, mapping)
        mapping = mapping.to_h { |from, to| [from.to_s, to.to_s] }
        each_node(root) { |node, _| node.type = mapping[node.type] if node.named? && mapping.key?(node.type) }
        root
      end

      ### Building nodes ###

      # A new node. Children can be nodes, or field: node pairs, and nils
      # are left out.
      def build(type, *children)
        nodes = children.flat_map do |child|
          next [child] unless child.is_a?(Hash)

          child.map { |field, node| node&.tap { node.field = field.to_s } }
        end
        Node.new(type, nodes.compact)
      end

      # A named leaf, such as an identifier, with a field name if given.
      def leaf(type, text, field: nil) = Node.leaf(type, text).tap { |node| node.field = field&.to_s }

      # A literal value (such as a string's contents), which the output
      # always writes in quotes.
      def literal(value) = Node.leaf("literal", value, quoted: true)

      # An anonymous token, such as "!".
      def token(text) = Node.token(text)

      def copy(node) = Engine.deep_copy(node)

      # The text of a node's leaves, joined.
      def text_of(node)
        return node.text if node.leaf?

        node.children.sum("") { |child| text_of(child) }
      end

      ### Names ###

      # Marks each leaf that holds a name the student chose, so the engine
      # writes a placeholder for it (see Placeholders). A name is the
      # student's if it is in `names`, and isn't in `kept`. A leaf in
      # `member_uses` (such as the name after a dot) refers to some other
      # object's member, so it is only marked if the name is also in
      # `members`, the members the solution defines.
      def mark_student_names(trees, language, names:, members:, member_uses:, kept:)
        renamed = names - kept
        member_uses = member_uses.to_set.compare_by_identity
        trees.each do |tree|
          Names.each_name(language, tree) do |leaf, name|
            leaf.renamed = renamed.include?(name) && (!member_uses.include?(leaf) || members.include?(name))
          end
        end
      end

      # The names held by the leaves captured as @name by the patterns.
      def names_in(trees, language, *pattern_sources)
        leaves = pattern_sources.flat_map { |source| trees.flat_map { |tree| captured(tree, source) } }
        leaves.select(&:leaf?).to_set { |leaf| leaf.text.delete_prefix(language.names.fetch(leaf.type, "")) }
      end

      private
      def pattern(source) = source.is_a?(String) ? PATTERNS[source] ||= Pattern.parse(source) : source
    end
  end
end
