# ruby_tree_sitter uses Pathname without requiring it. Bundler loads it
# locally, but the Lambda runtime doesn't.
require "pathname"
require "tree_sitter"
require "yaml"
require "rbconfig"

module Representer
  module Engine
    # Loads a compiled tree-sitter grammar (see grammars.yml and
    # bin/build-grammars) and parses source code into Engine::Node trees.
    #
    # Each grammar is loaded once per process and its parser is reused, so
    # this isn't thread-safe. A Lambda handles one request at a time.
    class Grammar
      ROOT = File.expand_path("../../..", __dir__)
      CONFIG = YAML.safe_load_file(File.join(ROOT, "grammars.yml"))
      EXTENSION = RbConfig::CONFIG["host_os"].include?("darwin") ? "dylib" : "so"

      def self.dir = ENV.fetch("REPRESENTER_GRAMMARS_DIR", File.join(ROOT, "grammars", "build"))
      def self.[](name) = (@cache ||= {})[name] ||= new(name)

      def initialize(name)
        config = CONFIG.fetch(name) { raise ArgumentError, "#{name} is not listed in grammars.yml" }
        path = File.join(self.class.dir, "#{name}.#{EXTENSION}")
        raise ArgumentError, "The #{name} grammar isn't built. Run bin/build-grammars #{name}" unless File.exist?(path)

        @parser = TreeSitter::Parser.new
        @parser.language = TreeSitter::Language.load(config.fetch("symbol", name), path)
      end

      # Parses the source and copies the tree into Engine::Nodes. Anonymous
      # tokens listed in skip_tokens are left out. A node whose type is listed
      # in text_types becomes a leaf that holds its whole source text, for
      # nodes whose text isn't made of child nodes (such as Gleam's
      # `gleam/list`, whose children are only the slashes).
      #
      # Some grammars leave the text between a node's children out of the
      # tree (Python's string_content holds only its escape sequences). For
      # the node types listed in gap_types, each stretch of text between the
      # children becomes a "fragment" leaf, so no text is lost.
      #
      # Raises CannotRepresent if the source has a syntax error (which
      # includes code too new for the grammar), or nests deeper than
      # max_depth.
      def parse(source, skip_tokens: Set.new, text_types: Set.new, max_depth: MAX_DEPTH, gap_types: Set.new)
        tree = @parser.parse_string(nil, source)
        raise CannotRepresent.new("parse_error", "The parser gave up") unless tree
        raise CannotRepresent.new("parse_error", "The code has a syntax error") if tree.root_node.has_error?

        build(tree.root_node, source, skip_tokens, text_types, max_depth, gap_types)
      end

      private
      # Walks the tree with a cursor, without recursion, so deep nesting can't
      # overflow the stack.
      def build(ts_root, source, skip_tokens, text_types, max_depth, gap_types)
        cursor = TreeSitter::TreeCursor.new(ts_root)
        root = copy(cursor.current_node, nil, source)
        gaps = Gaps.new(source, gap_types)
        gaps.enter(root, cursor.current_node)
        parents = [root]

        loop do
          if cursor.goto_first_child
            raise CannotRepresent.new("too_deep", "The code nests too deeply") if parents.size > max_depth
          else
            gaps.leave(parents.pop)
            until cursor.goto_next_sibling
              return root unless cursor.goto_parent

              gaps.leave(parents.pop)
            end
          end

          ts_node = cursor.current_node
          parent = parents.last
          gaps.before_child(parent, ts_node)
          if !ts_node.named? && skip_tokens.include?(type_of(ts_node, source))
            parents << nil # A placeholder, so the pop when leaving this node is balanced.
            next
          end

          node = copy(ts_node, cursor.current_field_name, source)
          gaps.enter(node, ts_node)
          parent&.children&.push(node)
          # Children of a skipped node are skipped too: their parent is nil.
          # So are the children of a text node, which holds their text.
          if text_types.include?(node.type)
            node.text = source.byteslice(ts_node.start_byte...ts_node.end_byte)
            parents << nil
          else
            parents << (parent && node)
          end
        end
      end

      # The node's type as a String. The tree-sitter binding can't turn a type
      # with non-ASCII characters into a Symbol (such as a Unicode minus sign).
      # An anonymous token's type is its text, so the source gives it.
      def type_of(ts_node, source)
        ts_node.type.to_s
      rescue EncodingError
        source.byteslice(ts_node.start_byte...ts_node.end_byte).force_encoding(Encoding::UTF_8)
      end

      # Keeps track of the text between the children of the nodes in gap_types
      # (see parse). The walk in build calls it as it goes.
      class Gaps
        Span = Struct.new(:from, :to)

        def initialize(source, types)
          @source = source
          @types = types
          @spans = {}.compare_by_identity
        end

        # A new node. If its type has gaps, the text from its start is next.
        def enter(node, ts_node)
          @spans[node] = Span.new(ts_node.start_byte, ts_node.end_byte) if @types.include?(node.type) && !node.leaf?
        end

        # The walk has reached a child of parent, so the text before it is a gap.
        def before_child(parent, ts_child)
          span = @spans[parent]
          return unless span

          add(parent, span.from, ts_child.start_byte)
          span.from = ts_child.end_byte
        end

        # The walk has left the node, so the text after its last child is a gap.
        def leave(node)
          span = @spans.delete(node)
          add(node, span.from, span.to) if span
        end

        private
        def add(node, from, to)
          return unless to > from

          node.children << Node.leaf("fragment", @source.byteslice(from...to))
        end
      end

      def copy(ts_node, field, source)
        type = type_of(ts_node, source)
        # An empty file's root has no children and no text. It isn't a leaf.
        empty = ts_node.end_byte == ts_node.start_byte
        bytes = ts_node.start_byte...ts_node.end_byte
        text = source.byteslice(bytes) if (ts_node.child_count.zero? && !empty) || !ts_node.named?
        Node.new(type, [], text:, named: ts_node.named?, field:, bytes:)
      end
    end
  end
end
