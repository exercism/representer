module Representer::Languages::Racket::Representation
  class Spec < Representer::Engine::Representation
    version 6

    # Rename symbols.
    names_are :symbol # «total»

    # Rename the names that GenerateAST marks as defined.
    names_are_defined_by :definition # (define («area» width) ...)

    # Drop these imports, because a solution that passes its tests has
    # already loaded every module it needs.
    imports "(require {{...}})",       # «(require racket/list)»
            "(require/typed {{...}})"  # «(require/typed racket/list [first (-> (Listof Integer) Integer)])»
  end
end
