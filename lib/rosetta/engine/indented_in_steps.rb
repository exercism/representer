module Rosetta::Engine
  # Says whether the source is indented with spaces, in steps of the width:
  # each line that isn't blank is indented as much as the line before it,
  # or by the width more or less. An analysis's rules use it for layout
  # (see AnalysisRules).
  #
  # "a\n  b\nc" is indented in steps of 2, and "a\n    b" and "a\n\tb" aren't.
  class IndentedInSteps
    include Mandate

    initialize_with :source, :width

    def call
      lines = source.lines.grep_v(/\A\s*\z/)
      return false if lines.any? { |line| line[/\A[ \t]*/].include?("\t") }

      lines.map { |line| line[/\A */].size }.each_cons(2).all? { |before, after| [0, width].include?((after - before).abs) }
    end
  end
end
