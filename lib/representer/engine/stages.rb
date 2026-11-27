module Representer::Engine
  # A staged language defines each stage it needs as a subclass of one of
  # these classes, beside its Spec, such as Ruby::GenerateAST. Each stage is
  # a Mandate command that takes one tree and returns the new tree, and
  # works on it with the helpers in TreeHelpers. REPRESENTER_DSL.md
  # describes the verbs.
  class Stage
    include Mandate
    include TreeHelpers

    initialize_with :tree

    # The Spec beside the stage, such as Ruby::Spec for Ruby::Normalise.
    def self.language = Object.const_get("#{name.rpartition('::').first}::Spec")
  end

  # A GenerateAST stage turns tree-sitter's tree into the tree given by
  # the language's own parser. Each language writes its own call method.
  class GenerateAST < Stage; end

  # A Normalise stage turns spellings that the representer treats as the
  # same into one, and removes code that makes no difference to a solution
  # working. It lists its rules with the verbs below, and the rules take
  # code patterns (see CodePattern):
  #
  #   class Normalise < Representer::Engine::Normalise
  #     drop_calls_to :puts
  #     rewrite "{{list}}.length", as: "{{list}}.size"
  #   end
  #
  # The stage applies its rules in the order they are listed, and each
  # rule visits every node once. The engine compiles the patterns with the
  # language that holds the stage.
  class Normalise < Stage
    # Removes every piece of code that matches one of the patterns.
    def self.drop(*codes, inside: nil) = rules << [:drop, codes, inside]

    # Removes every call to one of these methods. The engine writes each
    # call as `name({{arguments}})`, so this suits a language that writes
    # calls that way.
    def self.drop_calls_to(*names) = drop(*names.map { |name| "#{name}({{arguments}})" })

    # Turns code that matches the pattern into the code given in as:. Each
    # placeholder in as: becomes a copy of its match. So
    # `rewrite "{{a}}.length", as: "{{a}}.size"` writes every `length`
    # call as a call to `size`. The rule works from the leaves up.
    def self.rewrite(code, as:, inside: nil) = rules << [:rewrite, [code], inside, as]

    # Moves each statement that matches one of the patterns into the
    # definition after it, so the two move together (see AttachToNext).
    # So `attach_to_next "@spec {{spec}}"` keeps each Elixir spec with its
    # function.
    def self.attach_to_next(*codes, inside: nil) = rules << [:attach_to_next, codes, inside]

    # Removes each line that matches one of the patterns, and marks every
    # definition after it with the line, up to the next of these lines
    # (see AttachToEachFollowing). A definition is code that matches one
    # of the patterns in to:. So
    # `attach_to_each_following "private", to: "def {{name}}\nend"` marks
    # each Ruby method after a `private` line as private.
    def self.attach_to_each_following(*codes, to:, inside: nil)
      rules << [:attach_to_each_following, codes, inside, Array(to)]
    end

    def self.rules = @rules ||= []

    def call = self.class.rules.reduce(tree) { |root, rule| apply(root, *rule) }

    private
    def apply(root, verb, codes, inside, option = nil)
      patterns = codes.map { |code| code_pattern(code, inside) }
      case verb
      when :drop
        patterns.each { |pattern| drop(root, pattern) }
        root
      when :rewrite
        replacement = code_pattern(option, inside)
        transform(root, patterns.first) { |match| replacement.build(match.captures) }
      when :attach_to_next
        AttachToNext.(root, patterns)
      when :attach_to_each_following
        AttachToEachFollowing.(root, patterns, option.map { |code| code_pattern(code, inside) })
      end
    end

    def code_pattern(code, inside) = CodePattern[self.class.language, code, inside:]
  end

  # A Reorder stage sorts code if its order makes no difference, by a key
  # that ignores names. It lists the node types to sort with `sort`:
  #
  #   class Reorder < Representer::Engine::Reorder
  #     sort :class_body, :hash
  #   end
  #
  # A language that needs more can add its own call method.
  class Reorder < Stage
    # Sorts the children of every node of these types (see SortChildren).
    def self.sort(*types) = sorted_types.concat(types)

    def self.sorted_types = @sorted_types ||= []

    def call = SortChildren.(tree, self.class.sorted_types)
  end
end
