module Representer::Languages::Elm
  class Spec < Representer::Engine::Language
    tracks "elm"
    grammar "elm"
    extensions ".elm"

    # Treat these as comments, including documentation.
    comments_are :line_comment,  # x = 1 «-- The answer»
                 :block_comment  # «{-| Says hello. -}»
  end
end
