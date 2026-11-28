module Rosetta::Languages::Jq::Common
  class Spec < Rosetta::Engine::Language
    tracks "jq"
    grammar "jq"
    extensions ".jq"

    # Treat these as comments.
    comments_are :comment # .x «# The answer»
  end
end
