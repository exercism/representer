module Representer::Languages::Scheme::Common
  class Spec < Representer::Engine::Language
    tracks "scheme"
    grammar "scheme"
    extensions ".scm"

    # Treat these as comments. A `#;` comments out the datum after it.
    comments_are :comment,       # (define x 1) «; The answer»
                 :block_comment, # «#| The answer |#» (define x 1)
                 :sexp_comment   # «#;(display x)»

    # Read each string, character and boolean as one leaf that holds its
    # source, because the grammar leaves their text out of the tree.
    text_nodes :string,    # «"hello"»
               :character, # «#\a»
               :boolean    # «#t»
  end
end
