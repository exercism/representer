module Representer::Engine
  # Every staged language is a class called Spec that subclasses this one,
  # in a module named after the language. The language's stages are classes
  # beside it in the same module, such as Ruby::GenerateAST.
  # REPRESENTER_DSL.md describes every declaration.
  class Language
    extend Representer::LanguageSetup

    # Each stage lives in a file named after it, in the language's folder,
    # and so does the language's snippet (see Engine::Snippet).
    STAGE_FILES = { GenerateAST: "generate_ast", Normalise: "normalise", Reorder: "reorder", Snippet: "snippet" }.freeze

    class << self
      # Ruby calls this when a language defines its Spec. If the language's
      # folder has a file for a stage, such as `languages/ruby/normalise.rb`,
      # Ruby will load that file the first time the engine asks for the
      # stage. If a language has no file for a stage, it doesn't run that
      # stage.
      def inherited(spec)
        super
        folder = File.expand_path("../languages/#{snake_case(spec.name.split('::')[-2])}", __dir__)
        STAGE_FILES.each do |stage, file|
          path = File.join(folder, "#{file}.rb")
          stages_of(spec).autoload(stage, path) if File.exist?(path)
        end
      end

      # Called by Representer when it picks a language for a track.
      def call(solution_files, exercise_files, trees: {}) = Represent.(self, solution_files, exercise_files, trees:)

      def staged? = true

      # The node types that are names (see REPRESENTER_DSL.md). A language
      # can call it more than once.
      def names_are(*types, without_prefix: "")
        @names = (@names || {}).merge(types.to_h { |type| [type.to_s, without_prefix] })
      end

      # The node types that define a name (see REPRESENTER_DSL.md). A
      # language can call it more than once.
      def names_are_defined_by(*types, **fields)
        added = types.to_h { |type| [type.to_s, nil] }.merge(fields.to_h { |type, field| [type.to_s, field.to_s] })
        @definitions = (@definitions || {}).merge(added)
      end

      # Whether the node is a name: a leaf of one of the types in names_are.
      def name?(node) = node.named? && node.leaf? && names.key?(node.type)

      # The name held by a name's leaf, without its prefix.
      def name_text(leaf) = leaf.text.delete_prefix(names[leaf.type])

      # The leaves of the names defined by the node (see names_are_defined_by).
      def names_defined_by(node)
        return [] unless @definitions&.key?(node.type)

        field = @definitions[node.type]
        children = field ? [node[field]].compact : node.children
        children.select { |child| name?(child) }
      end

      # The node types that hold their whole source text as a leaf, for
      # nodes whose text the grammar doesn't give as children (see
      # REPRESENTER_DSL.md). With no arguments, it returns the types.
      def text_nodes(*types) = (@text_nodes ||= Set.new).merge(types.map(&:to_s))

      # The node types whose children don't cover all their text (see
      # REPRESENTER_DSL.md). Each stretch of text between the children
      # becomes a "fragment" leaf. With no arguments, it returns the types.
      def text_between_children(*types) = (@text_between_children ||= Set.new).merge(types.map(&:to_s))

      # How Grammar#parse copies a tree for this language.
      def parse_options = { text_types: text_nodes, gap_types: text_between_children }

      # The code that counts as an import, as code patterns (see
      # REPRESENTER_DSL.md). With no arguments, it returns the compiled
      # patterns.
      def imports(*codes)
        return @import_patterns ||= (@imports || []).map { |code| CodePattern[self, code] } if codes.empty?

        @imports = codes
      end

      # The code to put a code pattern in when the pattern doesn't parse on
      # its own (see REPRESENTER_DSL.md).
      def pattern_contexts(*contexts) = contexts.empty? ? @pattern_contexts || [] : @pattern_contexts = contexts

      # Runs the language's stage with this name on the tree, and returns
      # the new tree. If the language doesn't define the stage, the tree
      # stays as it is.
      def run_stage(name, tree) = stages.const_defined?(name, false) ? stages.const_get(name, false).(tree) : tree

      # The module that holds the Spec and its stages, such as
      # Representer::Languages::Ruby.
      def stages = stages_of(self)

      private
      def stages_of(spec) = Object.const_get(spec.name.delete_suffix("::Spec"))
      def snake_case(name) = name.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end
  end
end
