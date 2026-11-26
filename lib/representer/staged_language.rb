module Representer
  # A language written as four stages. The language is a module that
  # extends StagedLanguage, and it holds four Mandate command classes, each
  # in its own file:
  #
  # 1. GenerateAST takes the tree that tree-sitter gives (with every token)
  #    and turns it into the tree that the language's own parser would give:
  #    it drops comments and the tokens that the parser drops, unwraps
  #    brackets that only group, and turns spellings that the parser treats
  #    as one into one tree.
  # 2. Normalise applies the representer's own equivalences and removals:
  #    the global decisions (such as dropping imports) and any decided for
  #    the language by a human.
  # 3. Rename decides which names are the student's and marks their leaves
  #    (see TreeHelpers#mark_student_names).
  # 4. Reorder sorts code whose order doesn't matter, by a key that ignores
  #    the names.
  #
  # Engine::Represent runs GenerateAST and Normalise on each file, Rename
  # on all the files together, joins the files in an order set by their
  # code, runs Reorder, and then numbers the placeholders and writes the
  # tree out. Each stage includes Engine::TreeHelpers for its work on the
  # tree.
  #
  # CONTRIBUTING.md explains how to write a language this way.
  module StagedLanguage
    include LanguageSetup

    # Called by Representer when it picks a language for a track.
    def call(solution_files, exercise_files) = Engine::Represent.(self, solution_files, exercise_files)

    def staged? = true

    # The stages see every token, so the parse keeps them all.
    def parse_options = {}
    def syntax_checks = []
  end
end
