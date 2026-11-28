module Rosetta::Languages::CommonLisp::Common
  class Spec < Rosetta::Engine::Language
    tracks "common-lisp"
    grammar "common_lisp"
    extensions ".lisp"

    # Treat these as comments.
    comments_are :comment,       # (+ x 1) «; The answer»
                 :block_comment  # «#| The answer |#» (+ x 1)

    # Read each character and string as one leaf that holds its source,
    # because the grammar leaves their text out of the tree.
    text_nodes :char_lit, # «#\a»
               :str_lit   # «"hello"»
  end
end
