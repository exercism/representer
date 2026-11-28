module Representer::Languages::Ruby::Common
  class Spec < Representer::Engine::Language
    tracks "ruby"
    grammar "ruby"
    extensions ".rb"

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»
  end
end
