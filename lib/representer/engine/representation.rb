module Representer::Engine
  # A language's representation output is a class called
  # Representation that subclasses this one, beside the language's Spec.
  # It declares the representation's version and the names and imports
  # that the representation works with (REPRESENTER_DSL.md describes every
  # declaration). The stages that only the representation needs are
  # classes inside it, such as Ruby::Representation::Reorder, in the
  # language's `representation/` folder.
  class Representation
    extend InheritDeclarations

    STAGE_FILES = { Normalise: "normalise", Reorder: "reorder" }.freeze

    declarations_in :@version, :@names, :@definitions, :@imports, :@pattern_contexts

    class << self
      # Ruby calls this when a language defines its Representation. The
      # engine then finds the representation's stages in its folder (see
      # AutoloadFiles).
      def inherited(output)
        super
        folder = Representer::Engine.folder_of(Representer::Engine.language_module(output))
        AutoloadFiles.(output, File.join(folder, "representation"), STAGE_FILES)
      end

      # The Spec of the language, such as Ruby::Spec.
      def language = Representer::Engine.language_module(self)::Spec

      # The representation's version. Bump it whenever the representation
      # of any solution could change, so the website knows to represent the
      # track's solutions again. Versions run from 2 to 32767, because the
      # old per-track representers all reported 1.
      def version(number = nil)
        return @version unless number
        raise ArgumentError, "A version must be from 2 to 32767" unless (2..32_767).cover?(number)

        @version = number
      end

      # The node types that are names (see REPRESENTER_DSL.md). A language
      # can call it more than once. With no arguments, it returns each
      # type with its prefix.
      def names_are(*types, without_prefix: "")
        @names = (@names || {}).merge(types.to_h { |type| [type.to_s, without_prefix] })
      end

      def names = @names || {}

      # The node types that define a name (see REPRESENTER_DSL.md). A
      # language can call it more than once.
      def names_are_defined_by(*types, **fields)
        added = types.to_h { |type| [type.to_s, nil] }.merge(fields.to_h { |type, field| [type.to_s, field.to_s] })
        @definitions = (@definitions || {}).merge(added)
      end

      def name?(node) = node.named? && node.leaf? && names.key?(node.type)

      def name_text(leaf) = leaf.text.delete_prefix(names[leaf.type])

      # The leaves of the names defined by the node (see names_are_defined_by).
      def names_defined_by(node)
        return [] unless @definitions&.key?(node.type)

        field = @definitions[node.type]
        children = field ? [node[field]].compact : node.children
        children.select { |child| name?(child) }
      end

      # The code that counts as an import, as code patterns (see
      # REPRESENTER_DSL.md). With no arguments, it returns the compiled
      # patterns.
      def imports(*codes)
        return @import_patterns ||= (@imports || []).map { |code| CodePattern[language, code] } if codes.empty?

        (@imports ||= []).concat(codes)
      end

      # The code to put a code pattern in when the pattern doesn't parse on
      # its own (see REPRESENTER_DSL.md).
      def pattern_contexts(*contexts) = (@pattern_contexts ||= []).concat(contexts)

      # Runs the representation's stage with this name on the tree, and
      # returns the new tree (see Engine.run_stage).
      def run_stage(name, tree) = Representer::Engine.run_stage(self, name, tree)
    end
  end
end
