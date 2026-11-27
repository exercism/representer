module Representer::Languages::CommonLisp
  class Representation < Representer::Engine::Representation
    version 8

    # Rename symbols and keywords. A keyword and a symbol with the same text
    # get the same placeholder, so `:twofer` and `twofer` stay one name.
    names_are :sym_lit,    # «count»
              :kwd_symbol  # :«count»

    # Rename the names that GenerateAST marks as defined.
    names_are_defined_by :definition,  # (defun «area» (width) ...)
                         :variable     # (let ((«total» 0)) ...)

    # Drop these imports and exports, because a solution that passes its
    # tests has already made every name it needs available.
    imports "(require {{...}})",        # «(require :asdf)»
            "(use-package {{...}})",    # «(use-package :cl-ppcre)»
            "(import {{...}})",         # «(import 'cl-ppcre:split)»
            "(export {{...}})",         # «(export 'twofer)»
            "(:use {{...}})",           # (defpackage :two-fer «(:use :cl)»)
            "(:import-from {{...}})",   # (defpackage :two-fer «(:import-from :uiop :split-string)»)
            "(:export {{...}})"         # (defpackage :two-fer «(:export :twofer)»)

    # Let code patterns use `cl` as a name, because it is the nickname of the
    # package `common-lisp`, although the grammar reads it as a keyword.
    keywords_used_as_names "cl" # (:use «:cl»)
  end
end
