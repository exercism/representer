module Inspector::Engine
  # Every language is a class called Spec that subclasses this one, in the
  # Common module of a module named after the language, such as
  # Ruby::Common::Spec. The Spec says what the language is and how its
  # files are read. Each output is a module beside Common, such as
  # Ruby::Representation, Ruby::Analysis and Ruby::Snippet, and holds the
  # output's settings as a class called Spec. Common holds the stages that
  # every output needs.
  # docs/common.md describes every declaration.
  class Language
    OUTPUT_FILES = { Representation: "representation/spec", Analysis: "analysis/spec", Snippet: "snippet/spec" }.freeze

    COMMON_FILES = { GenerateAST: "generate_ast", Normalise: "normalise" }.freeze

    class << self
      # Ruby calls this when a language defines its Spec. The engine then
      # finds the language's outputs and common stages in its folder (see
      # AutoloadFiles), and Ruby loads each one the first time the engine
      # asks for it. If a language has no file for a stage, it doesn't run
      # that stage.
      def inherited(spec)
        super
        language = Inspector::Engine.language_module(spec)
        folder = Inspector::Engine.folder_of(language)
        AutoloadFiles.(language, folder, OUTPUT_FILES)
        AutoloadFiles.(Inspector::Engine.output_module(spec), File.join(folder, "common"), COMMON_FILES)
      end

      # Called by Inspector when it picks a language for a track.
      def call(solution_files, trees: {}) = Represent.(self, solution_files, trees:)

      # The tracks that the language represents. With no arguments, it
      # returns them.
      def tracks(*slugs)
        (@tracks ||= []).concat(slugs)
        slugs.each { |slug| Inspector::Languages.register(slug, self) }
        @tracks
      end

      # The name of the language's grammar in grammars.yml. With no
      # argument, it returns the name.
      def grammar(name = nil) = name ? @grammar = name : @grammar

      # The file extensions of the language's source files. Solution files
      # with other extensions (such as Cargo.toml) are ignored. With no
      # arguments, it returns the extensions.
      def extensions(*list) = list.empty? ? @extensions : @extensions = list

      def source_file?(filename) = extensions.any? { |extension| filename.downcase.end_with?(extension) }

      # The node types that are comments (see docs/common.md). The
      # engine drops them before GenerateAST, and the snippet removes them.
      # With no arguments, it returns the types.
      def comments_are(*types) = (@comment_types ||= []).concat(types.map(&:to_s))

      def comment_types = comments_are

      # The code that counts as a docstring, as code patterns (see
      # docs/common.md). The snippet removes it, and an output's
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
      # docs/common.md). With no arguments, it returns the types.
      def text_nodes(*types) = (@text_nodes ||= Set.new).merge(types.map(&:to_s))

      # The node types whose children don't cover all their text (see
      # docs/common.md). Each stretch of text between the children
      # becomes a "fragment" leaf. With no arguments, it returns the types.
      def text_between_children(*types) = (@text_between_children ||= Set.new).merge(types.map(&:to_s))

      # How Grammar#parse copies a tree for this language.
      # The text of the comments that the grammar doesn't know, as a regular
      # expression, and the code that a comment can't be inside, such as a
      # string (see docs/common.md). The engine blanks them out before
      # parsing.
      def comment_text(pattern, outside: nil) = @comment_text = { pattern:, outside: }

      def parse_options
        options = { text_types: text_nodes, gap_types: text_between_children }
        @comment_text ? options.merge(comment_text: @comment_text) : options
      end

      # The settings of the language's representation, such as
      # Ruby::Representation::Spec, or nil if it has none.
      def representation = output(:Representation)

      # The settings of the language's analysis, such as Ruby::Analysis::Spec,
      # or nil if it has none.
      def analysis = output(:Analysis)

      # The settings of the language's snippet, such as Ruby::Snippet::Spec,
      # or nil if it has none.
      def snippet = output(:Snippet)

      # The representation's version. A response gives it even when the
      # solution can't be represented.
      def version = representation.version

      # The module that holds the Spec and the stages every output needs,
      # such as Ruby::Common.
      def common = Inspector::Engine.output_module(self)

      # Runs the common stage with this name on the tree, and returns the
      # new tree (see Engine.run_stage).
      def run_stage(name, tree) = Inspector::Engine.run_stage(common, name, tree)

      # The module that holds Common and the outputs, such as
      # Inspector::Languages::Ruby.
      def stages = Inspector::Engine.language_module(self)

      private
      def output(name)
        return nil unless stages.const_defined?(name, false)

        owner = stages.const_get(name, false)
        owner.const_defined?(:Spec, false) ? owner::Spec : nil
      end
    end
  end

  # Returns the module of the language that holds the class: the nearest
  # module around it whose Common holds a Spec. So
  # Ruby::Representation::Normalise belongs to Inspector::Languages::Ruby.
  def self.language_module(klass)
    parts = klass.name.split("::")
    parts.pop until parts.empty? || language_module?(Object.const_get(parts.join("::")))
    raise ArgumentError, "#{klass.name} isn't inside a language with a Common::Spec" if parts.empty?

    Object.const_get(parts.join("::"))
  end

  # Whether the module is a language's own module, such as
  # Inspector::Languages::Ruby, which holds Ruby::Common::Spec.
  def self.language_module?(owner) = owner.const_defined?(:Common, false) && owner::Common.const_defined?(:Spec, false)

  # Returns the module that holds an output's Spec, such as
  # Ruby::Representation for Ruby::Representation::Spec.
  def self.output_module(spec) = Object.const_get(spec.name.delete_suffix("::Spec"))

  # Languages whose names are one word, although they have a capital inside.
  # JavaScript  ->  `languages/javascript/`
  ONE_WORD_NAMES = %w[JavaScript PureScript TypeScript].freeze

  # Returns the folder of a language, such as `languages/ruby/` for
  # Inspector::Languages::Ruby. A capital after a lower-case letter starts
  # a new word, unless the name is in ONE_WORD_NAMES.
  # EmacsLisp  ->  `languages/emacs_lisp/`
  # CSharp  ->  `languages/csharp/`
  def self.folder_of(language) = folder_named(language.name)

  # Returns the folder of the language with this module name, such as
  # `languages/ruby/` for "Inspector::Languages::Ruby" (see folder_of).
  def self.folder_named(module_name)
    name = module_name.split("::").last
    name = name.gsub(/([a-z\d])([A-Z])/, '\1_\2') unless ONE_WORD_NAMES.include?(name)
    File.expand_path("../languages/#{name.downcase}", __dir__)
  end

  # Runs the stage with this name from the module on the tree, and returns
  # the new tree. If the module doesn't define the stage, the tree stays as
  # it is.
  def self.run_stage(owner, name, tree) = owner.const_defined?(name, false) ? owner.const_get(name, false).(tree) : tree
end
