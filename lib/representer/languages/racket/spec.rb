module Representer::Languages::Racket
  class Spec < Representer::Engine::Language
    tracks "racket"
    grammar "racket"
    extensions ".rkt"

    # Treat these as comments. A `#;` comments out the form after it.
    comments_are :comment,       # (define x 1) «; The answer»
                 :block_comment, # «#| The answer |#» (define x 1)
                 :sexp_comment   # «#;(displayln x)» (define x 1)

    # Read each string and regular expression as one leaf that holds its
    # source, because the grammar leaves their text out of the tree.
    text_nodes :string,      # «"hello"»
               :byte_string, # «#"hello"»
               :regex,       # «#rx"[a-z]+"»
               :here_string  # «#<<END ... END»

    # Keep the kind of each hash, such as `#hasheq`, because the grammar
    # leaves it out of the tree.
    text_between_children :hash # «#hasheq»((a . 1))
  end
end
