module Inspector::Languages::EmacsLisp::Representation
  class Spec < Inspector::Engine::Representation
    version 7

    # Rename symbols, including quoted ones, so `'two-fer` in `provide` gets
    # the same placeholder as the function `two-fer`.
    names_are :symbol # «count», '«count»

    # Rename the names that GenerateAST marks as defined.
    names_are_defined_by :definition,  # (defun «area» (width) ...), (defvar «total» 0)
                         :variable     # (let ((«total» 0)) ...), (lambda («x») x)

    # Drop these imports, because a solution that passes its tests has
    # already loaded every feature it needs.
    imports "(require {{...}})" # «(require 'cl-lib)»
  end
end
