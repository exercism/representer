# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Scheme solution's snippet, so that the card
# shows the student's own code. docs/dsl.md explains each declaration.
module Representer::Languages::Scheme::Snippet
  class Spec < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, including each `#;` datum, wherever it is.
    remove :comments # (define x 1) «; The answer»

    # Skip the imports and module declarations at the top of the file, up to the first other statement.
    skip_at_top "(import",        # «(import (rnrs))»
                "(use-modules",   # «(use-modules (srfi srfi-1))»
                "(define-module"  # «(define-module (leap))»
  end
end
