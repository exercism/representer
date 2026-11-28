# REPRESENTER_DSL.md defines the verbs in this file.
# The tests call Acronym.abbreviate with a phrase.
module Representer::Languages::Ruby::Analysis
  class Acronym < Representer::Engine::AnalysisRules
    within ["class Acronym; {{...}}; end", "module Acronym; {{...}}; end"] do
      # Suggest `map(&:chr)` in place of a block that only calls `chr`.
      uses('def self.abbreviate({{phrase}}); ' \
           '{{phrase}}.tr("-", " ").split({{...}}).map { |{{word}}| {{word}}.chr }.join.upcase; end') do
        informative "ruby.acronym.block_syntax.shorthand"
      end
    end
  end
end
