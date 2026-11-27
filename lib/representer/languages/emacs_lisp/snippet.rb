# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Emacs Lisp solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::EmacsLisp
  class Snippet < Representer::Engine::Snippet
    tracks "emacs-lisp"

    # Remove every comment, wherever it is.
    remove :comments # (setq x 1) «; The answer»

    # Skip the requires at the top of the file, up to the first other statement.
    skip_at_top "(require" # «(require 'cl-lib)»
  end
end
