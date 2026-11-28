# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Common Lisp solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::CommonLisp::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Remove every comment, wherever it is.
    remove :comments # (defun f () 1) «; The answer»

    # Skip the package declarations at the top of the file, up to the first other statement.
    skip_at_top "(defpackage", # «(defpackage :leap (:use :cl))»
                "(in-package"  # «(in-package :leap)»
  end
end
