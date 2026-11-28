module Representer::Languages::Jq::Common
  class Spec < Representer::Engine::Language
    tracks "jq"
    grammar "jq"
    extensions ".jq"

    # Treat these as comments.
    comments_are :comment # .x «# The answer»
  end
end
