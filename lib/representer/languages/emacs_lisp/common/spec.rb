module Representer::Languages::EmacsLisp::Common
  class Spec < Representer::Engine::Language
    tracks "emacs-lisp"
    grammar "elisp"
    extensions ".el"

    # Treat these as comments.
    comments_are :comment # (setq x 1) «; The answer»
  end
end
