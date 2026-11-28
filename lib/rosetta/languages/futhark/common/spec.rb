module Rosetta::Languages::Futhark::Common
  class Spec < Rosetta::Engine::Language
    tracks "futhark"
    grammar "futhark"
    extensions ".fut"

    # Treat these as comments, including documentation comments.
    comments_are :comment # def x = 1 «-- The answer»
  end
end
