module Rosetta::Languages::Kotlin::Common
  class Spec < Rosetta::Engine::Language
    tracks "kotlin"
    grammar "kotlin"
    extensions ".kt"

    # Treat these as comments, including KDoc.
    comments_are :line_comment,      # val x = 1 «// The answer»
                 :multiline_comment  # «/** Says hello. */»

    # Read these literals as their whole text, because the grammar leaves out
    # their characters and suffixes.
    text_nodes :character_literal, # «'a'»
               :long_literal,      # «1L»
               :unsigned_literal   # «1uL»

    # Keep the quotes around a string, because the grammar leaves them out and
    # they show whether the string is raw.
    text_between_children :string_literal # «"""»a«"""»
  end
end
