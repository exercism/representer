module Representer
  # A staged language is a module that extends StagedLanguage. It declares
  # its setup, its names and its imports, and defines the stages it needs as
  # classes, each in its own file:
  #
  # 1. GenerateAST (a subclass of Engine::GenerateAST) takes the tree given
  #    by tree-sitter (with every token) and turns it into the tree given by
  #    the language's own parser. It drops comments and the tokens dropped
  #    by the parser, unwraps brackets that only group, and turns spellings
  #    that the parser treats as one into one tree.
  # 2. Normalise (a subclass of Engine::Normalise) applies any equivalences
  #    and removals that a human has decided for the language.
  # 3. Reorder (a subclass of Engine::Reorder) sorts code if its order makes
  #    no difference, by a key that ignores the names.
  #
  # The engine runs only the stages that a language defines (see
  # Engine::RepresentWithStages for the order). It also makes the decisions
  # that apply to every language. It drops the language's imports after
  # GenerateAST, renames every name the solution defines (see
  # Engine::RenameUserDefinedNodes), keeps the language's library names,
  # leaves out file names, orders the files by their code, numbers the
  # placeholders, and refuses invalid code.
  #
  # CONTRIBUTING.md explains how to write a language this way.
  module StagedLanguage
    include LanguageSetup

    LIBRARY_NAMES = File.join(__dir__, "languages", "library_names")

    # Called by Representer when it picks a language for a track.
    def call(solution_files, exercise_files) = Engine::Represent.(self, solution_files, exercise_files)

    def staged? = true

    # Lists the node types that are names, after GenerateAST. A keyword
    # gives a prefix that isn't part of the name, such as Ruby's
    # `simple_symbol: ":"` for `:name`.
    #
    #   names_are :identifier, :constant, simple_symbol: ":"
    def names_are(*types, **prefixed) = names(*types, **prefixed)

    # Lists the node types that define a name, after GenerateAST. A type
    # given on its own defines each of its children that is a name. A type
    # given with a field defines only the child in that field.
    #
    #   names_are_defined_by :method_parameters, assignment: :left
    def names_are_defined_by(*types, **fields)
      @definitions = types.to_h { |type| [type.to_s, nil] }.merge(fields.to_h { |type, field| [type.to_s, field.to_s] })
    end

    # Whether the node is a name: a leaf of one of the types in names_are.
    def name?(node) = node.named? && node.leaf? && names.key?(node.type)

    # The name held by a name's leaf, without its prefix.
    def name_text(leaf) = leaf.text.delete_prefix(names[leaf.type])

    # The leaves of the names that the node defines (see
    # names_are_defined_by).
    def names_defined_by(node)
      return [] unless @definitions&.key?(node.type)

      field = @definitions[node.type]
      children = field ? [node[field]].compact : node.children
      children.select { |child| name?(child) }
    end

    # Lists the code that counts as an import, as code patterns (see
    # Engine::CodePattern). Every solution that the representer sees passes
    # its tests, so it has already loaded everything it needs, and the
    # engine drops this code from every file (see Engine::DropImports).
    #
    #   imports 'require "{{file}}"'
    def imports(*codes)
      return @import_patterns ||= (@imports || []).map { |code| Engine::CodePattern[self, code] } if codes.empty?

      @imports = codes
    end

    # Lists the code to put a code pattern in when the pattern doesn't parse
    # on its own. The engine tries the contexts in order. Each context marks
    # the pattern's place with `...`. In Ruby, `"...\nend"` would let
    # `def {{method}}({{x}})` parse.
    def pattern_contexts(*contexts) = contexts.empty? ? @pattern_contexts || [] : @pattern_contexts = contexts

    # Returns the library names. The engine reads them from
    # languages/library_names/<track>.txt. A name in this list keeps its
    # name, even if the solution defines it, so `def sum(a) = a.sum` and
    # `def max(a) = a.max` stay apart.
    def library
      return @library_names if @library_names

      path = File.join(LIBRARY_NAMES, "#{tracks.first}.txt")
      File.exist?(path) ? library_names(path) : @library_names = Set.new
    end

    # Runs the language's stage with this name on the tree, and returns the
    # new tree. If the language doesn't define the stage, the tree stays as
    # it is.
    def run_stage(name, tree) = const_defined?(name, false) ? const_get(name, false).(tree) : tree
  end
end
