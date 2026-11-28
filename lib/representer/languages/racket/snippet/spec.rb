# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Racket solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Representer::Languages::Racket::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # (define x 1) «; The answer»

    # Skip the language line, provides and requires at the top of the file, up to the first other statement.
    skip_at_top "#lang",    # «#lang racket»
                "(provide", # «(provide leap-year?)»
                "(require"  # «(require racket/list)»
  end
end
