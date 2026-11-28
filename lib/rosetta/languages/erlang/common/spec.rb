module Rosetta::Languages::Erlang::Common
  class Spec < Rosetta::Engine::Language
    tracks "erlang"
    grammar "erlang"
    extensions ".erl", ".hrl"

    # Treat these as comments.
    comments_are :comment # X = 1, «% The answer»
  end
end
