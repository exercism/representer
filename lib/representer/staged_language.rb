module Representer
  # A staged language is written as four stages. The language is a module
  # that extends StagedLanguage, and it holds four classes, each in its own
  # file:
  #
  # 1. GenerateAST takes the tree given by tree-sitter (with every token)
  #    and turns it into the tree given by the language's own parser. It
  #    drops comments and the tokens dropped by the parser, unwraps
  #    brackets that only group, and turns spellings that the parser treats
  #    as one into one tree. It is a Mandate command that works on the tree
  #    with Engine::TreeHelpers.
  # 2. Normalise applies any equivalences and removals that a human has
  #    decided for the language. It lists its rules with the verbs in
  #    Engine::NormaliseStage.
  # 3. Rename decides which names are the student's. It lists its rules
  #    with the verbs in Engine::RenameStage.
  # 4. Reorder sorts code if its order makes no difference, by a key that
  #    ignores the names. It extends Engine::ReorderStage.
  #
  # The engine makes the decisions that apply to every language. It drops
  # the language's imports after GenerateAST, keeps the language's library
  # names, leaves out file names, orders the files by their code, numbers
  # the placeholders, and refuses invalid code.
  #
  # Engine::Represent runs GenerateAST and Normalise on each file (see
  # prepare), Rename on all the files together, joins the files in an order
  # set by their code, runs Reorder, and then numbers the placeholders and
  # writes the tree out.
  #
  # CONTRIBUTING.md explains how to write a language this way.
  module StagedLanguage
    include LanguageSetup

    LIBRARY_NAMES = File.join(__dir__, "languages", "library_names")

    # Called by Representer when it picks a language for a track.
    def call(solution_files, exercise_files) = Engine::Represent.(self, solution_files, exercise_files)

    def staged? = true

    # Lists the code that counts as an import, as code patterns (see
    # Engine::CodePattern). Every solution that the representer sees passes
    # its tests, so it has already loaded everything it needs, and the
    # engine drops this code from every file.
    #
    #   imports 'require "$file"'
    def imports(*codes)
      return @import_patterns ||= (@imports || []).map { |code| Engine::CodePattern[self, code] } if codes.empty?

      @imports = codes
    end

    # Lists the code to put a code pattern in when the pattern doesn't parse
    # on its own. The engine tries the contexts in order. Each context marks
    # the pattern's place with `...`. Ruby gives `"...\nend"`, so that
    # `def $method($name)` parses.
    def pattern_contexts(*contexts) = contexts.empty? ? @pattern_contexts || [] : @pattern_contexts = contexts

    # Returns the library names. The engine reads them from
    # languages/library_names/<track>.txt. A member named after one of them
    # keeps its name, so `def sum(a) = a.sum` and `def max(a) = a.max` stay
    # apart.
    def library
      return @library_names if @library_names

      path = File.join(LIBRARY_NAMES, "#{tracks.first}.txt")
      File.exist?(path) ? library_names(path) : @library_names = Set.new
    end

    # Turns one file's tree-sitter tree into the tree seen by Rename. It runs
    # the language's GenerateAST, drops the imports, and then runs the
    # language's Normalise.
    def prepare(tree)
      tree = self::GenerateAST.(tree)
      imports.each { |pattern| Engine::Stage::TREE.drop(tree, pattern) }
      self::Normalise.(tree)
    end

    # The stages see every token, so the parse keeps them all.
    def parse_options = {}
    def syntax_checks = []
  end
end
