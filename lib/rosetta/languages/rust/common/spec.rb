module Rosetta::Languages::Rust::Common
  class Spec < Rosetta::Engine::Language
    tracks "rust"
    grammar "rust"
    extensions ".rs"

    # Treat these as comments, including doc comments.
    comments_are :line_comment,  # let x = 1; «// The answer», «/// Says hello.»
                 :block_comment  # «/* The answer */»
  end
end
