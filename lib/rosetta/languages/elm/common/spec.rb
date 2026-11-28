module Rosetta::Languages::Elm::Common
  class Spec < Rosetta::Engine::Language
    tracks "elm"
    grammar "elm"
    extensions ".elm"

    # Treat these as comments, including documentation.
    comments_are :line_comment,  # x = 1 «-- The answer»
                 :block_comment  # «{-| Says hello. -}»
  end
end
