module Rosetta::Languages::Prolog::Common
  class Spec < Rosetta::Engine::Language
    tracks "prolog"
    grammar "prolog"
    extensions ".pl"

    # Treat these as comments.
    comments_are :comment # X = 1, «% The answer»
  end
end
