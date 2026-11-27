module Representer::Engine
  # A language defines each stage it needs as a subclass of one of
  # these classes, such as Ruby::Common::GenerateAST or
  # Ruby::Representation::Reorder. Each stage is a Mandate command that
  # takes one tree and returns the new tree, and works on it with the
  # helpers in TreeHelpers. REPRESENTER_DSL.md describes the verbs.
  class Stage
    include Mandate
    include TreeHelpers
    extend InheritDeclarations

    initialize_with :tree

    # The Spec of the language that holds the stage, such as Ruby::Spec for
    # Ruby::Common::Normalise.
    def self.language = Representer::Engine.language_module(self)::Spec
  end

  # A GenerateAST stage turns tree-sitter's tree into the tree given by
  # the language's own parser. Each language writes its own call method,
  # and lists the shared steps as declarations at the top of its class:
  #
  #   class GenerateAST < Representer::Engine::GenerateAST
  #     strip_tokens "def", "end", "(", ")"
  #     unwrap :parenthesized_statements
  #     numbers_are integer: :integer, decimal: :float
  #   end
  #
  # The engine drops the comments declared in the Spec and writes the
  # numbers before the language's own steps. The language's steps can
  # still read the brackets and the tokens, so the engine unwraps the
  # brackets and strips the tokens after them.
  class GenerateAST < Stage
    declarations_in :@stripped_tokens, :@stripped_tokens_in, :@kept_tokens_in, :@unwrapped_types, :@numbers,
                    :@list_types

    class << self
      # Strips these anonymous tokens (keywords and punctuation) from every
      # node, or only from the node types given in only_in.
      def strip_tokens(*tokens, only_in: nil)
        return stripped_tokens.concat(tokens) unless only_in

        Array(only_in).each { |type| (stripped_tokens_in[type.to_s] ||= []).concat(tokens) }
      end

      # Keeps these tokens in the node types given in `in:`, although
      # strip_tokens strips them from every other node.
      def keep_tokens(*tokens, **where)
        Array(where.fetch(:in)).each { |type| (kept_tokens_in[type.to_s] ||= []).concat(tokens) }
      end

      # Replaces each node of these types that holds one named child with
      # that child, for brackets that only group (see UnwrapBrackets).
      def unwrap(*types) = unwrapped_types.concat(types.map(&:to_s))

      # Gives the first item of each node of these types the field name
      # `head`, for a grammar that gives a form's items no field names (see
      # LabelListHeads). A code pattern then matches a list only by its
      # first item.
      def lists_are(*types) = list_types.concat(types.map(&:to_s))

      # Writes each number leaf of these types as its value (see
      # WriteNumbersAsValues). integer, decimal and number each take a type
      # or a list of types. prefixes maps each base prefix of an integer to
      # its base, suffixes lists the type suffixes a decimal may end with,
      # and separators lists the characters that may separate digits.
      def numbers_are(integer: [], decimal: [], number: [], prefixes: Numbers::PREFIXES, suffixes: [],
                      separators: ["_"])
        types = { integer:, decimal:, number: }.transform_values { |given| Array(given).map(&:to_s) }
        @numbers = { **types, prefixes:, suffixes:, separators: }
      end

      def numbers = @numbers || {}
      def stripped_tokens = @stripped_tokens ||= []
      def stripped_tokens_in = @stripped_tokens_in ||= {}
      def kept_tokens_in = @kept_tokens_in ||= {}
      def unwrapped_types = @unwrapped_types ||= []
      def list_types = @list_types ||= []

      # Runs the engine's steps around the language's own call method.
      def call(tree)
        tree = DropComments.(tree, language.comment_types)
        tree = WriteNumbersAsValues.(tree, **numbers)
        tree = super(tree)
        tree = LabelListHeads.(tree, list_types)
        tree = UnwrapBrackets.(tree, unwrapped_types)
        StripTokens.(tree, stripped_tokens, only_in: stripped_tokens_in, kept_in: kept_tokens_in)
      end
    end
  end

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
    declarations_in :@rules

    # Removes every piece of code that matches one of the patterns.
    # `drop :docstrings` removes the docstrings declared in the Spec.
    def self.drop(*codes, inside: nil) = rules << [:drop, codes, inside]

    # Removes every call to one of these methods. The engine writes each
    # call as `name({{...}})`, so this suits a language that writes calls
    # that way.
    def self.drop_calls_to(*names) = drop(*names.map { |name| "#{name}({{...}})" })

    # Turns code that matches the pattern into the code given in as:. Each
    # placeholder in as: becomes a copy of its match. So
    # `rewrite "{{a}}.length", as: "{{a}}.size"` writes every `length`
    # call as a call to `size`. The rule works from the leaves up. With
    # within:, the rule only applies inside code that matches one of those
    # patterns, and a word in both must match the same code (see
    # RewriteCode).
    def self.rewrite(code, as:, inside: nil, within: [])
      rules << [:rewrite, [code], inside, { as:, within: Array(within) }]
    end

    # Moves each statement that matches one of the patterns into the
    # definition after it, so the two move together (see AttachToNext).
    # So `attach_to_next "@spec {{...}}"` keeps each Elixir spec with its
    # function. The statements move past any statement that matches a
    # pattern in past:, and `past: :docstrings` gives the docstrings
    # declared in the Spec.
    def self.attach_to_next(*codes, past: [], inside: nil) = rules << [:attach_to_next, codes, inside, Array(past)]

    # Removes each line that matches one of the patterns, and marks every
    # definition after it with the line, up to the next of these lines
    # (see AttachToEachFollowing). A definition is code that matches one
    # of the patterns in to:. So
    # `attach_to_each_following "private", to: "def {{...}}\nend"` marks
    # each Ruby method after a `private` line as private.
    def self.attach_to_each_following(*codes, to:, inside: nil)
      rules << [:attach_to_each_following, codes, inside, Array(to)]
    end

    # Puts braces around a body that has none (see AddBraces). Each
    # pattern marks the body with `{{body}}`, such as
    # `add_braces_to "if ({{...}}) {{body}}"`. block: gives the block's
    # type, for a grammar that reads empty braces as something else.
    def self.add_braces_to(*codes, inside: nil, block: nil) = rules << [:add_braces_to, codes, inside, block]

    def self.rules = @rules ||= []

    def call = self.class.rules.reduce(tree) { |root, rule| apply(root, *rule) }

    private
    def apply(root, verb, codes, inside, option = nil)
      case verb
      when :drop
        patterns(codes, inside).each { |pattern| drop(root, pattern) }
        root
      when :rewrite
        RewriteCode.(root, code_pattern(codes.first, inside), code_pattern(option[:as], inside),
          scopes: option[:within].map { |code| code_pattern(code, nil) })
      when :attach_to_next
        AttachToNext.(root, patterns(codes, inside), past: patterns(option, inside))
      when :attach_to_each_following
        AttachToEachFollowing.(root, patterns(codes, inside), patterns(option, inside))
      when :add_braces_to
        codes.reduce(root) { |tree, code| add_braces(tree, code, inside, option) }
      end
    end

    def code_pattern(code, inside) = CodePattern[self.class.language, code, inside:]

    def add_braces(tree, code, inside, block)
      return AddBraces.(tree, code_pattern(code, inside), block:) if block

      AddBraces.(tree, code_pattern(code.sub("{{body}}", "{ }"), inside))
    end

    # The patterns for the codes, where :docstrings gives the docstrings
    # declared in the Spec.
    def patterns(codes, inside)
      codes.flat_map { |code| code == :docstrings ? self.class.language.docstrings : [code_pattern(code, inside)] }
    end
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
    declarations_in :@sorted_types

    # Sorts the children of every node of these types (see SortChildren).
    def self.sort(*types) = sorted_types.concat(types)

    def self.sorted_types = @sorted_types ||= []

    def call = SortChildren.(tree, self.class.sorted_types)
  end
end
