module Representer::Languages::Wasm
  class Spec < Representer::Engine::Language
    tracks "wasm"
    grammar "wat"
    extensions ".wat"

    # Keep the whole text of these, because the grammar leaves out a string's
    # text, apart from its escapes.
    text_nodes :string # «"a\n"»

    # Treat these as comments.
    comments_are :line_comment,  # (i32.const 1) «;; The answer»
                 :block_comment  # «(; The answer ;)»
  end
end
