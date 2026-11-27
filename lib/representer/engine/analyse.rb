module Representer::Engine
  # Analyses a solution in its language, and returns the comments of
  # the exercise's rules (see AnalysisRules). An exercise with no rules gets
  # no comments.
  #
  # The rules look at the solution's main file (see FindMainFile). The
  # engine parses it, and runs the language's common GenerateAST and
  # Normalise stages and the analysis's own Normalise stage on it. The
  # analysis keeps the imports, and the student's names.
  #
  # Raises CannotRepresent if the main file is too large or doesn't parse.
  class Analyse
    include Mandate

    initialize_with :analysis, :exercise_slug, :solution_files, :exercise_files

    def call
      rules = analysis.rules_for(exercise_slug)
      return [] unless rules

      rules.(tree, source)
    end

    private
    def tree
      language = analysis.language
      tree = Grammar[language.grammar].parse(source, **language.parse_options)
      tree = language.run_stage(:GenerateAST, tree)
      tree = language.run_stage(:Normalise, tree)
      analysis.run_stage(:Normalise, tree)
    end

    memoize
    def source
      source = solution_files.fetch(FindMainFile.(solution_files, exercise_files))
      if source.bytesize > Representer::MAX_SOLUTION_BYTES
        raise Representer::CannotRepresent.new("too_large", "The main file is over #{Representer::MAX_SOLUTION_BYTES} bytes")
      end

      Representer::Engine.clean(source)
    end
  end
end
