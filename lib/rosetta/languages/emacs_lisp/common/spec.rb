module Rosetta::Languages::EmacsLisp::Common
  class Spec < Rosetta::Engine::Language
    tracks "emacs-lisp"
    grammar "elisp"
    extensions ".el"

    # Treat these as comments.
    comments_are :comment # (setq x 1) «; The answer»
  end
end
