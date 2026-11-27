module Representer::Languages::Scheme
  class Representation < Representer::Engine::Representation
    version 7

    # Rename symbols.
    names_are :symbol # «count»

    # Rename the names that GenerateAST marks as defined.
    names_are_defined_by :definition # (define («area» «width») ...)

    # Drop these imports, because a solution that passes its tests has
    # already made every library it needs available.
    imports "(import {{...}})",        # «(import (rnrs))»
            "(use-modules {{...}})",   # «(use-modules (srfi srfi-1))»
            "(define-module {{...}})", # «(define-module (leap) #:export (leap-year?))»
            "(export {{...}})"         # (library (leap) «(export leap-year?)» ...)
  end
end
