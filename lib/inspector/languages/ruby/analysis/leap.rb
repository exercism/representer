# docs/analysis.md defines the verbs in this file.
# The tests call Year.leap? with a year.
module Inspector::Languages::Ruby::Analysis
  class Leap < Inspector::Engine::AnalysisRules
    within ["class Year; {{...}}; end", "module Year; {{...}}; end"] do
      # Ask for the rule to be written out, because the exercise is about
      # writing it.
      within ["def self.leap?({{...}}); {{...}}; end", "def self.leap?({{...}}) = {{_}}"] do
        uses(["Date.leap?({{...}})", "Date.gregorian_leap?({{...}})", "Date.julian_leap?({{...}})"]) { actionable "ruby.leap.std_lib" }
      end
    end
  end
end
