module Rosetta::Languages::Wren::Common
  class Spec < Rosetta::Engine::Language
    tracks "wren"
    grammar "wren"
    extensions ".wren"

    # Treat these as comments.
    comments_are :line_comment,  # var x = 1 «// The answer»
                 :block_comment  # «/* The answer */» var x = 1

    # Read a raw string as one leaf, because the grammar gives it no children
    # for its text.
    text_nodes :raw_string
  end
end
