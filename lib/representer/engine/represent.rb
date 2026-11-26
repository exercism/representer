module Representer
  module Engine
    # Represents one solution with one language's rules (see Language).
    #
    # Only the solution files with one of the language's extensions are
    # represented, as the website also sends files such as Rust's Cargo.toml.
    #
    # Raises CannotRepresent if the solution has no such file, if a file
    # can't be parsed, or if the rules hit one of the engine's limits (see
    # MAX_REWRITES_PER_NODE and MAX_SECONDS). The solution then gets no
    # representation.
    class Represent
      include Mandate

      initialize_with :language, :solution_files, :exercise_files

      def call
        @deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + MAX_SECONDS
        sources = solution_files.select { |filename, _| language.source_file?(filename) }
        if sources.empty?
          raise CannotRepresent.new("no_source_files", "No solution file has one of the extensions #{language.extensions.join(', ')}")
        end

        trees = sources.sort.map { |filename, source| [filename, prepare(source)] }
        trees = [[language.merge_files, merge(trees.map(&:last))]] if language.merges_files?
        names = Names.new(language, trees.map(&:last), required_names)
        representation = trees.map { |filename, tree| Serialize.(tree, names, filename) }.join("\n")

        Result.new(representation:, mapping: names.mapping, version: language.version, representer: language)
      end

      private
      # Parses the source and applies the drop and rewrite rules.
      def prepare(source)
        tree = Grammar[language.grammar].parse(
          Engine.clean(source), skip_tokens: language.dropped_tokens, kept_tokens: language.kept_tokens,
          text_types: language.text_node_types, gap_types: language.gap_types
        )
        drop(tree)
        rewrite(tree)
      end

      # Joins the files' trees into one and applies the rewrite rules to the
      # whole.
      def merge(trees)
        return trees.first if trees.one?

        root = Node.new(trees.first.type, trees.flat_map(&:children))
        rewrite(root)
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
      # rule's output is always fully rewritten. The rewrites of a node and
      # of the nodes that replace it count together, so two rules that undo
      # each other hit MAX_REWRITES_PER_NODE too.
      def rewrite(node, rewrites = 0)
        node.children.map! do |child|
          rewritten = rewrite(child)
          rewritten.field = child.field
          rewritten
        end

        loop do
          check_time
          replacement = apply_first_rewrite(node)
          return node if replacement.nil?

          rewrites += 1
          if rewrites > MAX_REWRITES_PER_NODE
            raise CannotRepresent.new("too_complex",
              "Rewrite rules keep matching #{node.type} in #{language.name}. A rule's output must not match its own pattern.")
          end

          replacement.field = node.field
          return rewrite(replacement, rewrites) unless replacement.equal?(node)
        end
      end

      def check_time
        return if Process.clock_gettime(Process::CLOCK_MONOTONIC) < @deadline

        raise CannotRepresent.new("too_complex", "The rules took more than #{MAX_SECONDS} seconds")
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
          next if filename.start_with?(".") || !language.source_file?(filename)

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

    # representer is the class that made the representation. reason says why
    # a solution has no representation (representation is then nil).
    Result = Struct.new(:representation, :mapping, :version, :representer, :reason, keyword_init: true)

    # Source code arrives as JSON strings, which are UTF-8 but may hold
    # invalid bytes from a student's editor. The editor also chooses Windows
    # line endings and a byte-order mark, so line endings become plain line
    # breaks and the mark goes. Otherwise they would end up in strings and in
    # other tokens (such as a C++ `#define`).
    def self.clean(source)
      source = source.dup.force_encoding(Encoding::UTF_8)
      source = source.scrub("�") unless source.valid_encoding?
      source.delete_prefix("\uFEFF").gsub("\r\n", "\n")
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
