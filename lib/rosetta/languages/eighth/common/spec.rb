module Rosetta::Languages::Eighth::Common
  class Spec < Rosetta::Engine::Language
    tracks "8th"
    grammar "eighth"
    extensions ".8th"

    # Treat these as comments.
    comments_are :comment # : f 1 ; «\ The answer»
  end
end
