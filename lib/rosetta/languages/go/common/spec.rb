module Rosetta::Languages::Go::Common
  class Spec < Rosetta::Engine::Language
    tracks "go"
    grammar "go"
    extensions ".go"

    # Treat these as comments.
    comments_are :comment # x := 1 «// The answer»
  end
end
