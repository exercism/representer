# This file says what Ruby is and how the representer reads its files.
# REPRESENTER_DSL.md explains each declaration. representation.rb and
# snippet.rb hold the settings of each output, and the folders hold Ruby's
# stages.
module Representer::Languages::Ruby
  class Spec < Representer::Engine::Language
    tracks "ruby"
    grammar "ruby"
    extensions ".rb"

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»
  end
end
