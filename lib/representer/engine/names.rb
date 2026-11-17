module Representer
  module Engine
    # Decides which names to replace with placeholders, using a language's
    # rename and keep rules (see Language), and hands out the placeholders.
    #
    # Renaming goes by name, not by scope: every use of a renamed name gets
    # the same placeholder, as the old per-track representers did.
    class Names
      attr_reader :member_defs, :mapping

      # Calls the block with every leaf that holds a name, and the name.
      def self.each_name(language, tree)
        tree.each_descendant do |node|
          next unless node.named? && node.leaf?

          prefix = language.names[node.type]
          yield node, node.text.delete_prefix(prefix) if prefix
        end
      end

      def initialize(language, trees, required)
        @language = language
        @local_defs = Set.new
        @member_defs = Set.new
        kept = language.kept_names | required

        trees.each do |tree|
          tree.each_descendant do |node|
            collect(language.local_rules, node) { |name| @local_defs << name }
            collect(language.member_rules, node) { |name| @member_defs << name }
            collect(language.keep_rules, node) { |name| kept << name }
            language.member_position_rules.each do |rule|
              Array(rule.match(node)&.[](:name)).each { |leaf| leaf.role = :member }
            end
          end
        end

        # A member named like a library method stays as it is, so that a
        # student's `sum` that calls the library's `sum` can't merge with a
        # student's `max` that calls `max`.
        @renameable = (@local_defs | @member_defs) - kept - (@member_defs & language.library)
        @placeholders = {}
        @mapping = {}
      end

      # The text to write for a leaf: a placeholder, or nil to keep its own
      # text. A placeholder loses the leaf's own text, which may have said
      # what kind of name it was (`@x` or `X` in Ruby). So a placeholder for
      # any type of name except the language's first is written with its
      # type: (instance_variable PLACEHOLDER_1).
      def text_for(leaf)
        prefix = @language.names[leaf.type] if leaf.named?
        return nil unless prefix

        name = leaf.text.delete_prefix(prefix)
        return nil unless rename?(leaf, name)

        text = "#{prefix}#{placeholder(name)}"
        leaf.type == @language.names.keys.first ? text : "(#{leaf.type} #{text})"
      end

      private
      def rename?(leaf, name)
        return false unless @renameable.include?(name)

        leaf.role != :member || @member_defs.include?(name)
      end

      def placeholder(name)
        @placeholders[name] ||= "PLACEHOLDER_#{@placeholders.size + 1}".tap { |placeholder| @mapping[placeholder] = name }
      end

      def collect(rules, node)
        rules.each do |rule|
          Array(rule.match(node)&.[](:name)).each do |leaf|
            next unless leaf.leaf?

            yield leaf.text.delete_prefix(@language.names.fetch(leaf.type, ""))
          end
        end
      end
    end

    # Writes a tree as an indented s-expression. Leaves are written as their
    # text, quoted if they hold a literal value or anything that could be
    # mistaken for the s-expression's own syntax.
    class Serialize
      include Mandate

      PLAIN = /\A[^\s()"\\]+\z/

      initialize_with :tree, :names, :filename

      def call
        out = +"(file #{filename.dump}"
        write_child(tree, 1, out)
        out << ")"
      end

      private
      def write(node, depth, out)
        out << "(" << node.type
        node.children.each { |child| write_child(child, depth + 1, out) }
        out << ")"
      end

      def write_child(node, depth, out)
        if node.leaf?
          out << " " << leaf_text(node)
        else
          out << "\n" << ("  " * depth)
          write(node, depth, out)
        end
      end

      def leaf_text(node)
        renamed = names.text_for(node)
        return renamed if renamed

        text = node.named? ? node.text : node.type
        !node.quoted && text.match?(PLAIN) ? text : text.dump
      end
    end
  end
end
