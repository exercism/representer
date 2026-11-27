module Representer
  module Engine
    # A staged language (see StagedLanguage) writes its Normalise, Rename
    # and Reorder stages with these modules. Each stage is a class that
    # extends one of them and lists its rules with the module's verbs. Each
    # rule takes code patterns (see CodePattern), so a stage reads as a list
    # of rules about code:
    #
    #   class Rename
    #     extend Engine::RenameStage
    #
    #     rename_locals "$name = $value", "@$name"
    #     rename_members "def $name"
    #   end
    #
    # The engine compiles the patterns the first time a stage runs. It
    # compiles them with the language around the stage class, such as Ruby
    # for Ruby::Rename.
    module Stage
      # The stages use TreeHelpers through this object, because some verbs
      # have the same names as the helpers (such as drop).
      TREE = Object.new.extend(TreeHelpers)

      def language = @language ||= Object.const_get(name.rpartition("::").first)

      private
      def rules = @rules ||= []

      def code_patterns(codes, inside) = codes.map { |code| CodePattern[language, code, inside:] }
    end

    # A Normalise stage turns spellings that the representer treats as the
    # same into one, and removes code that makes no difference to a solution
    # working. The stage applies its rules in the order they are listed, and
    # each rule visits every node once.
    module NormaliseStage
      include Stage

      # Removes every piece of code that matches one of the patterns.
      def drop(*codes, inside: nil) = rules << [:drop, codes, inside]

      # Removes every call to one of these methods. The engine writes each
      # call as `name($arguments)`, so this suits a language that writes
      # calls that way.
      def drop_calls_to(*names) = drop(*names.map { |name| "#{name}($arguments)" })

      # Turns code that matches the pattern into the code given in as:. Each
      # placeholder in as: becomes a copy of its match. So
      # `rewrite "$a.length", as: "$a.size"` writes every `length` call as a
      # call to `size`. The rule works from the leaves up.
      def rewrite(code, as:, inside: nil) = rules << [:rewrite, [code], inside, as]

      def call(tree)
        rules.reduce(tree) do |root, (verb, codes, inside, template)|
          patterns = code_patterns(codes, inside)
          case verb
          when :drop
            patterns.each { |pattern| TREE.drop(root, pattern) }
            root
          when :rewrite
            replacement = CodePattern[language, template, inside:]
            TREE.transform(root, patterns.first) { |match| replacement.build(match.captures) }
          end
        end
      end
    end

    # A Rename stage decides which names are the student's. Each of its
    # patterns marks a name with `$name`.
    #
    # If a rename_locals or rename_members pattern matches a name, the
    # engine renames that name everywhere it appears. The engine keeps every
    # name used in the exercise's tests, the members defined in the
    # exercise's stub, the names matched by keep, and any member named after
    # one of the language's library names (see StagedLanguage#library).
    module RenameStage
      include Stage

      # Marks the names of local variables and parameters, which the
      # solution gives their whole meaning.
      def rename_locals(*codes, inside: nil) = rules << [:locals, codes, inside]

      # Marks the names of members defined in the solution, such as methods
      # and classes. The engine also renames these names where other code
      # uses them (see rename_member_uses), and keeps the members of the
      # exercise's stub.
      def rename_members(*codes, inside: nil) = rules << [:members, codes, inside]

      # Marks the places where a name refers to some other object's member,
      # such as the name after a dot. The engine only renames a name there if
      # the solution defines a member with that name.
      def rename_member_uses(*codes, inside: nil) = rules << [:member_uses, codes, inside]

      # Marks names that are never renamed, such as keyword parameters, which
      # callers pass by name.
      def keep(*codes, inside: nil) = rules << [:kept, codes, inside]

      # Marks the student's names in the trees, and returns the names of the
      # members defined in the trees. The engine keeps these names when it
      # reads them from an exercise's stub.
      def call(trees, kept_names)
        found = find_names(trees)
        members = found[:members]
        kept = kept_names | found[:kept] | (members & language.library)
        TREE.mark_student_names(trees, language, names: found[:locals] | members, members:,
          member_uses: found[:member_uses], kept:)
        members
      end

      private
      # Returns the names matched by each kind of rule, and the leaves
      # matched by the member_uses rules.
      def find_names(trees)
        found = { locals: Set.new, members: Set.new, kept: Set.new, member_uses: [] }
        trees.each do |tree|
          tree.each_descendant do |node|
            patterns_for(node.type).each do |kind, pattern|
              pattern.matches(node).each do |bindings|
                leaf = bindings[CodePattern::SUBJECT]
                kind == :member_uses ? found[kind] << leaf : found[kind] << name_of(leaf)
              end
            end
          end
        end
        found
      end

      def name_of(leaf) = leaf.text.delete_prefix(language.names.fetch(leaf.type, ""))

      def patterns_for(type)
        @patterns_by_type ||= {}
        @patterns_by_type[type] ||= compiled_rules.select { |_, pattern| Engine.could_match?(pattern, type) }
      end

      def compiled_rules
        @compiled_rules ||= rules.flat_map do |kind, codes, inside|
          code_patterns(codes, inside).map do |pattern|
            raise ArgumentError, "The pattern #{pattern.code.inspect} needs a $name" unless pattern.subject?

            [kind, pattern]
          end
        end
      end
    end

    # A Reorder stage sorts code if its order makes no difference, by a key
    # that ignores names. A stage with no rules keeps the order of
    # everything, and no language needs a rule yet.
    module ReorderStage
      include Stage

      def call(tree) = tree
    end
  end
end
