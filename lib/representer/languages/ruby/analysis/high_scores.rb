# REPRESENTER_DSL.md defines the verbs in this file.
# The tests create a HighScores with a list of scores, and call its methods.
class Representer::Languages::Ruby::Analysis
  class HighScores < Representer::Engine::AnalysisRules
    # Look for a class with six members, which are these methods in any
    # order, and a reader for the scores.
    within "class HighScores; {{...}}; {{...}}; {{...}}; {{...}}; {{...}}; {{...}}; end", exactly: true do
      uses_all(["def initialize(scores); @scores = scores; end",
                "def personal_best; scores.max; end",
                "def latest; scores.last; end",
                "def personal_top_three; scores.max(3); end",
                "def latest_is_personal_best?; latest == personal_best; end"],
          exactly: true) do
        first_of do
          uses("attr_reader :scores", exactly: true) do
            actionable "ruby.general.incorrect_indentation" unless indented_in_steps_of?(2)
          end

          # Suggest `attr_reader` in place of a method that returns the scores.
          uses("def scores; @scores; end", exactly: true) do
            next actionable "ruby.general.incorrect_indentation" unless indented_in_steps_of?(2)

            actionable "ruby.high-scores.attr_reader"
          end
        end
      end
    end
  end
end
