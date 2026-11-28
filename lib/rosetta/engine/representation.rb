module Rosetta::Engine
  # A language's representation output is a module called Representation,
  # beside the language's Common module, in the language's
  # `representation/` folder. Its settings are a class called Spec that
  # subclasses this one, such as Ruby::Representation::Spec. The Spec
  # declares the representation's version and the names and imports that
  # the representation works with (docs/representation.md describes every
  # declaration). The stages that only the representation needs are
  # classes beside the Spec, such as Ruby::Representation::Reorder.
  class Representation
    extend InheritDeclarations

    STAGE_FILES = { Normalise: "normalise", Reorder: "reorder" }.freeze

    declarations_in :@version, :@names, :@definitions, :@imports, :@pattern_contexts, :@placeholder_suffix,
                    :@keywords_used_as_names

    class << self
      # Ruby calls this when a language defines its Representation::Spec.
      # The engine then finds the representation's stages in its folder
      # (see AutoloadFiles).
      def inherited(spec)
        super
        folder = Rosetta::Engine.folder_of(Rosetta::Engine.language_module(spec))
        AutoloadFiles.(Rosetta::Engine.output_module(spec), File.join(folder, "representation"), STAGE_FILES)
      end

      # The Spec of the language, such as Ruby::Common::Spec.
      def language = Rosetta::Engine.language_module(self)::Common::Spec

      # The representation's version. Bump it whenever the representation
      # of any solution could change, so the website knows to represent the
      # track's solutions again. Versions run from 2 to 32767, because the
      # old per-track representers all reported 1.
      def version(number = nil)
        return @version unless number
        raise ArgumentError, "A version must be from 2 to 32767" unless (2..32_767).cover?(number)

        @version = number
      end

      # The node types that are names (see docs/representation.md). A language
      # can call it more than once. With no arguments, it returns each
      # type with its prefix.
      def names_are(*types, without_prefix: "")
        @names = (@names || {}).merge(types.to_h { |type| [type.to_s, without_prefix] })
      end

      def names = @names || {}

      # The node types that define a name (see docs/representation.md). A
      # language can call it more than once.
      def names_are_defined_by(*types, **fields)
        added = types.to_h { |type| [type.to_s, nil] }.merge(fields.to_h { |type, field| [type.to_s, field.to_s] })
        @definitions = (@definitions || {}).merge(added)
      end

      def name?(node) = node.named? && node.leaf? && names.key?(node.type)

      def name_text(leaf) = leaf.text.delete_prefix(names[leaf.type])

      # The leaves of the names defined by the node (see names_are_defined_by).
      # A field can hold several children, as Go's `var a, b int` does, and
      # each of them that is a name counts.
      def names_defined_by(node)
        return [] unless @definitions&.key?(node.type)

        field = @definitions[node.type]
        children = field ? node.children.select { |child| child.field == field } : node.children
        children.select { |child| name?(child) }
      end

      # The code that counts as an import, as code patterns (see
      # docs/representation.md). With no arguments, it returns the compiled
      # patterns.
      def imports(*codes)
        return @import_patterns ||= (@imports || []).map { |code| CodePattern[language, code] } if codes.empty?

        (@imports ||= []).concat(codes)
      end

      # The code to put a code pattern in when the pattern doesn't parse on
      # its own (see docs/code-patterns.md).
      def pattern_contexts(*contexts) = (@pattern_contexts ||= []).concat(contexts)

      # The text that ends each placeholder's spelling in a code pattern,
      # such as `name__` for `{{name}}` (see docs/code-patterns.md).
      def placeholder_suffix(suffix = nil)
        return @placeholder_suffix || "__" unless suffix

        @placeholder_suffix = suffix
      end

      # The grammar's keywords that the language also uses as names, so a
      # code pattern may use them as names (see docs/code-patterns.md).
      def keywords_used_as_names(*words) = (@keywords_used_as_names ||= []).concat(words)

      # Runs the representation's stage with this name on the tree, and
      # returns the new tree (see Engine.run_stage).
      def run_stage(name, tree) = Rosetta::Engine.run_stage(Rosetta::Engine.output_module(self), name, tree)
    end
  end
end
