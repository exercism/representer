module Representer
  module Engine
    # Represents one solution with one language's rules (see Language).
    #
    # Only the solution files with one of the language's extensions are
    # represented, as the website also sends files such as Rust's Cargo.toml.
    # The files are joined into one tree, and their names are never part of
    # the representation.
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
        sources = solution_files.select { |filename, _| language.source_file?(filename) && !Engine.test_or_config_file?(filename) }
        if sources.empty?
          raise CannotRepresent.new("no_source_files", "No solution file has one of the extensions #{language.extensions.join(', ')}")
        end

        trees = sources.values.map { |source| prepare(source) }
        return staged(trees) if language.staged?

        tree = merge(in_order(trees))
        names = Names.new(language, [tree], required_names)
        result(tree, names)
      end

      private
      # Parses the source, and applies a staged language's GenerateAST and
      # Normalise stages (see StagedLanguage#prepare), or another language's
      # drop and rewrite rules.
      def prepare(source)
        tree = parse(source)
        @root_type = tree.type
        return language.prepare(tree) if language.staged?

        drop(tree)
        rewrite(tree)
      end

      # The rest of a staged language's stages (see StagedLanguage): Rename
      # marks the student's names in every file, the files are joined,
      # Reorder sorts the whole, and Placeholders numbers the names as the
      # tree is written out.
      def staged(trees)
        language::Rename.(trees, required_names)
        tree = language::Reorder.(join(in_order(trees)))
        result(tree, Placeholders.new(language))
      end

      def result(tree, names)
        Result.new(representation: Serialize.(tree, names), mapping: names.mapping, version: language.version,
          representer: language)
      end

      def parse(source)
        source = Engine.clean(source)
        tree = Grammar[language.grammar].parse(source, **language.parse_options)
        language.syntax_checks.each do |check|
          problem = check.(source, tree)
          raise CannotRepresent.new("parse_error", problem) if problem
        end
        tree
      end

      # The files' trees in an order that depends only on the code, so the
      # files' names and order never change the representation. Each tree is
      # written out with every name that will be renamed left blank, and the
      # trees are sorted by that. Trees that are the same apart from those
      # names are sorted by the names as written.
      def in_order(trees)
        return trees if trees.one?

        names = language.staged? ? Placeholders.new(language) : Names.new(language, trees, required_names)
        trees.sort_by { |tree| [Serialize.(tree, names, blank: true), Serialize.(tree, nil)] }
      end

      # Joins the files' trees into one and applies the rewrite rules to the
      # whole, so the rules for a whole file (such as one that sorts its
      # declarations) run on all of the solution's code. Splitting code
      # across files then changes the representation as little as possible.
      def merge(trees) = trees.one? ? trees.first : rewrite(join(trees))

      # Joins the files' trees into one. A rule may have replaced a file's
      # root (Crystal unwraps a file that holds one class), so such a file
      # joins as one child.
      def join(trees)
        return trees.first if trees.one?

        Node.new(@root_type, trees.flat_map { |tree| tree.type == @root_type ? tree.children : [tree] })
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
      # defines. Exercise files that don't parse are ignored. A test's names
      # are read before the rules drop anything too, so a name that only
      # appears in a test's import (`use TwoFer;`) still counts.
      #
      # A stub is a file that `.meta/config.json` lists as a solution file, or
      # that has the name of one of the student's files. So a student who
      # names their file differently from the stub keeps only the stub's
      # members, and not every name in it.
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

          if stub?(filename)
            names.merge(language.staged? ? language::Rename.([tree], Set.new) : Names.new(language, [tree], Set.new).member_defs)
          else
            [tree, parse(source)].each { |names_tree| Names.each_name(language, names_tree) { |_leaf, name| names << name } }
          end
        end
        names
      end

      def stub?(filename) = solution_files.key?(filename) || stub_names.include?(filename)

      # The solution files listed in the exercise's config.
      memoize
      def stub_names
        config = JSON.parse(exercise_files.fetch(".meta/config.json", "{}"))
        listed = config.is_a?(Hash) && config["files"].is_a?(Hash) ? config["files"]["solution"] : nil
        Array(listed).grep(String).to_set
      rescue JSON::ParserError
        Set.new
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
    # An old Mac line ending (a carriage return on its own) is a line break
    # too. A NUL byte is replaced like an invalid byte, as the website can't
    # store it.
    def self.clean(source)
      source = source.dup.force_encoding(Encoding::UTF_8)
      source = source.scrub("�") unless source.valid_encoding?
      source.delete_prefix("\uFEFF").gsub(/\r\n?/, "\n").tr("\0", "�")
    end

    # Files that students submit alongside their solution but that aren't
    # part of it: tests (`two_fer_test.rb`, `test_two_fer.py`, `leap.spec.js`,
    # `LeapTest.java`, `LeapTests.cs`), Go's `embed.go`, and tool configs
    # (`babel.config.js`, `.eslintrc.js`). The old representers ignored them.
    TEST_OR_CONFIG_FILE = %r{
      (\A|[_.])(test|spec)s?\.[^./]+\z |
      \Atest_[^/]*\.py\z |
      [a-z0-9]Tests?\.[^./]+\z |
      \Aembed\.go\z |
      \.config\.[cm]?[jt]s\z |
      \A\.eslintrc
    }x

    def self.test_or_config_file?(filename) = File.basename(filename).match?(TEST_OR_CONFIG_FILE)

    # Whether a pattern could match a node of this type, judging only by
    # the type at the pattern's root.
    def self.could_match?(pattern, type)
      case pattern
      when CodePattern then pattern.type.nil? || pattern.type == type
      when Pattern::NodePattern then ["_", type].include?(pattern.type)
      when Pattern::Alternation then pattern.options.any? { |option| could_match?(option, type) }
      else true
      end
    end
  end
end
