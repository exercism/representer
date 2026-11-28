module Inspector::Languages::Odin::Common
  class Spec < Inspector::Engine::Language
    tracks "odin"
    grammar "odin"
    extensions ".odin"

    # Treat these as comments.
    comments_are :comment,       # x := 1 «// The answer»
                 :block_comment  # «/* The answer */»

    # Read characters as leaves, because the grammar gives a character such
    # as `','` only its quotes and a token.
    text_nodes :character
  end
end
