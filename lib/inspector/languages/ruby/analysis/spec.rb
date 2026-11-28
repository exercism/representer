# The analysis gives a student comments on their solution. Each exercise
# with comments has a file of rules in `analysis/`, such as
# `analysis/two_fer.rb`. docs/analysis.md explains each verb.
module Inspector::Languages::Ruby::Analysis
  class Spec < Inspector::Engine::Analysis
    # Bump the version whenever the comments on any solution could change.
    version 2
  end
end
