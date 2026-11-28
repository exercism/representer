module Rosetta::Languages::Arturo::Common
  class Spec < Rosetta::Engine::Language
    tracks "arturo"
    grammar "arturo"
    extensions ".art"

    # Treat these as comments.
    comments_are :comment # x: 1 «; The answer»
  end
end
