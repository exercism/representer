module Representer::Engine
  # Every staged language is a class called Spec that subclasses this one,
  # in a module named after the language. The Spec says what the language
  # is and how its files are read. Each output is a class beside it, such
  # as Ruby::Representation, Ruby::Analysis and Ruby::Snippet, and the
  # stages that every output needs sit in a module beside it, such as
  # Ruby::Common.
  # REPRESENTER_DSL.md describes every declaration.
  class Language
    extend Representer::LanguageSetup

    OUTPUT_FILES = { Representation: "representation", Analysis: "analysis", Snippet: "snippet" }.freeze

    COMMON_FILES = { GenerateAST: "generate_ast", Normalise: "normalise" }.freeze

    class << self
      # Ruby calls this when a language defines its Spec. The engine then
      # finds the language's outputs and common stages in its folder (see
      # AutoloadFiles), and Ruby loads each one the first time the engine
      # asks for it. If a language has no file for a stage, it doesn't run
      # that stage.
      def inherited(spec)
        super
        language = Representer::Engine.language_module(spec)
        folder = Representer::Engine.folder_of(language)
        AutoloadFiles.(language, folder, OUTPUT_FILES)
        common = language.const_defined?(:Common, false) ? language::Common : language.const_set(:Common, Module.new)
        AutoloadFiles.(common, File.join(folder, "common"), COMMON_FILES)
      end

      # Called by Representer when it picks a language for a track.
      def call(solution_files, exercise_files, trees: {}) = Represent.(self, solution_files, exercise_files, trees:)

      def staged? = true

      # The node types that are comments (see REPRESENTER_DSL.md). The
      # engine drops them before GenerateAST, and the snippet removes them.
      # With no arguments, it returns the types.
      def comments_are(*types) = (@comment_types ||= []).concat(types.map(&:to_s))

      def comment_types = comments_are

      # The code that counts as a docstring, as code patterns (see
      # REPRESENTER_DSL.md). The snippet removes it, and an output's
      # Normalise stage can drop it with `drop :docstrings`.
      def docstrings_are(*codes) = @docstring_codes = codes

      # The docstring patterns, compiled for the tree from GenerateAST, or
      # for the grammar's own tree if raw.
      def docstrings(raw: false)
        (@docstrings ||= {})[raw] ||= (@docstring_codes || []).map { |code| CodePattern[self, code, raw:] }
      end

      # Whether the node is a docstring, in the grammar's own tree.
      def docstring?(node) = docstrings(raw: true).any? { |pattern| pattern.match(node) }

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

      # The language's representation output, such as Ruby::Representation,
      # or nil if it has none.
      def representation = stages.const_defined?(:Representation, false) ? stages::Representation : nil

      # The language's analysis output, such as Ruby::Analysis, or nil if it
      # has none.
      def analysis = stages.const_defined?(:Analysis, false) ? stages::Analysis : nil

      # The representation's version. A response gives it even when the
      # solution can't be represented.
      def version = representation.version

      # The module that holds the stages every output needs, such as
      # Ruby::Common.
      def common = stages::Common

      # Runs the common stage with this name on the tree, and returns the
      # new tree (see Engine.run_stage).
      def run_stage(name, tree) = Representer::Engine.run_stage(common, name, tree)

      # The module that holds the Spec and its outputs, such as
      # Representer::Languages::Ruby.
      def stages = Representer::Engine.language_module(self)
    end
  end

  # Returns the module of the language that holds the class: the nearest
  # module around it that holds a Spec. So Ruby::Common::Normalise belongs
  # to Representer::Languages::Ruby.
  def self.language_module(klass)
    parts = klass.name.split("::")
    parts.pop until parts.empty? || Object.const_get(parts.join("::")).const_defined?(:Spec, false)
    raise ArgumentError, "#{klass.name} isn't inside a language with a Spec" if parts.empty?

    Object.const_get(parts.join("::"))
  end

  # Returns the folder of a staged language, such as `languages/ruby/` for
  # Representer::Languages::Ruby.
  def self.folder_of(language)
    name = language.name.split("::").last.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    File.expand_path("../languages/#{name}", __dir__)
  end

  # Runs the stage with this name from the module on the tree, and returns
  # the new tree. If the module doesn't define the stage, the tree stays as
  # it is.
  def self.run_stage(owner, name, tree) = owner.const_defined?(name, false) ? owner.const_get(name, false).(tree) : tree
end
