# The analysis gives a student comments on their solution. Each exercise
# with comments has a file of rules in `analysis/`, such as
# `analysis/two_fer.rb`. docs/dsl.md explains each verb.
module Representer::Languages::Ruby::Analysis
  class Spec < Representer::Engine::Analysis
    # Bump the version whenever the comments on any solution could change.
    version 2
  end
end
