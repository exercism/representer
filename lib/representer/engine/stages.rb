module Representer
  module Engine
    # A staged language (see StagedLanguage) defines each stage it needs as
    # a subclass of one of these classes, such as
    # `class GenerateAST < Engine::GenerateAST`. Each stage is a Mandate
    # command that takes one tree and returns the new tree, and works on it
    # with the helpers in TreeHelpers.
    class Stage
      include Mandate
      include TreeHelpers

      initialize_with :tree

      # The language that holds the stage, such as Ruby for Ruby::Normalise.
      def self.language = Object.const_get(name.rpartition("::").first)
    end

    # A GenerateAST stage turns tree-sitter's tree into the tree given by
    # the language's own parser. Each language writes its own call method.
    class GenerateAST < Stage; end

    # A Normalise stage turns spellings that the representer treats as the
    # same into one, and removes code that makes no difference to a solution
    # working. It lists its rules with the verbs below, and the rules take
    # code patterns (see CodePattern):
    #
    #   class Normalise < Engine::Normalise
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

      def self.rules = @rules ||= []

      def call
        self.class.rules.reduce(tree) do |root, (verb, codes, inside, template)|
          patterns = codes.map { |code| CodePattern[self.class.language, code, inside:] }
          case verb
          when :drop
            patterns.each { |pattern| drop(root, pattern) }
            root
          when :rewrite
            replacement = CodePattern[self.class.language, template, inside:]
            transform(root, patterns.first) { |match| replacement.build(match.captures) }
          end
        end
      end
    end

    # A Reorder stage sorts code if its order makes no difference, by a key
    # that ignores names. Each language writes its own call method.
    class Reorder < Stage; end
  end
end
