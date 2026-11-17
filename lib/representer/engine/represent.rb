module Representer
  module Engine
    # Represents one solution with one language's rules (see Language).
    #
    # Raises CannotRepresent if a solution file can't be parsed, and the
    # caller then falls back to Basic.
    class Represent
      include Mandate

      MAX_REWRITES_PER_NODE = 50

      initialize_with :language, :solution_files, :exercise_files

      def call
        trees = solution_files.sort.map { |filename, source| [filename, prepare(source)] }
        names = Names.new(language, trees.map(&:last), required_names)
        representation = trees.map { |filename, tree| Serialize.(tree, names, filename) }.join("\n")

        Result.new(representation:, mapping: names.mapping, version: language.version, representer: language)
      end

      private
      # Parses the source and applies the drop and rewrite rules.
      def prepare(source)
        tree = Grammar[language.grammar].parse(
          Engine.clean(source), skip_tokens: language.dropped_tokens, text_types: language.text_node_types
        )
        drop(tree)
        rewrite(tree)
      end

      def drop(root)
        stack = [root]
        until stack.empty?
          node = stack.pop
          node.children.reject! { |child| rules_for(language.drop_rules, child).any? { |rule| rule.match(child) } }
          stack.concat(node.children)
        end
      end

      # Applies the rewrite rules from the leaves up. When a rule replaces a
      # node, the rules run again on the replacement (and its children), so a
      # rule's output is always fully rewritten.
      def rewrite(node)
        node.children.map! do |child|
          rewritten = rewrite(child)
          rewritten.field = child.field
          rewritten
        end

        MAX_REWRITES_PER_NODE.times do
          replacement = apply_first_rewrite(node)
          return node if replacement.nil?

          replacement.field = node.field
          node = replacement.equal?(node) ? node : rewrite(replacement)
        end
        raise "Rewrite rules keep matching #{node.type} in #{language.name}. A rule's output must not match its own pattern."
      end

      # Runs the first rule that matches the node and changes it (a rule's
      # block can return nil to say it changed nothing), and returns the
      # node's replacement. Returns nil if no rule changed the node.
      def apply_first_rewrite(node)
        rules_for(language.rewrite_rules, node).each do |rule|
          match = rule.match(node)
          replacement = match && rule.action.(match)
          return replacement if replacement
        end
        nil
      end

      # The rules worth trying on a node: those whose pattern starts with the
      # node's type, plus those that can start with anything, in the order
      # the language lists them.
      def rules_for(rules, node)
        @rule_index ||= {}
        @rule_index[[rules.object_id, node.type]] ||= rules.select { |rule| Engine.could_match?(rule.pattern, node.type) }
      end

      # Names that the exercise fixes: every name in the tests (and any other
      # exercise file that isn't the stub), and the members that the stub
      # defines. Exercise files that don't parse are ignored.
      memoize
      def required_names
        names = Set.new
        exercise_files.each do |filename, source|
          next if filename.start_with?(".")
          next unless language.extensions.any? { |extension| filename.end_with?(extension) }

          begin
            tree = prepare(source)
          rescue CannotRepresent
            next
          end

          if solution_files.key?(filename)
            names.merge(Names.new(language, [tree], Set.new).member_defs)
          else
            Names.each_name(language, tree) { |_leaf, name| names << name }
          end
        end
        names
      end
    end

    # representer is the class that made the representation. It isn't part of
    # the response, but tests use it to see whether a solution fell back.
    Result = Struct.new(:representation, :mapping, :version, :representer, keyword_init: true)

    # Source code arrives as JSON strings, which are UTF-8 but may hold
    # invalid bytes from a student's editor.
    def self.clean(source)
      source = source.dup.force_encoding(Encoding::UTF_8)
      source.valid_encoding? ? source : source.scrub("�")
    end

    # Whether a pattern could match a node of this type, judging only by
    # the type at the pattern's root.
    def self.could_match?(pattern, type)
      case pattern
      when Pattern::NodePattern then ["_", type].include?(pattern.type)
      when Pattern::Alternation then pattern.options.any? { |option| could_match?(option, type) }
      else true
      end
    end
  end
end
