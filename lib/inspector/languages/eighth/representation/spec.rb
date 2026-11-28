module Inspector::Languages::Eighth::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename words.
    names_are :identifier, # : «double» 2 * ;
              :word        # 3 «double»

    # Rename the words defined with `:`, `constant` and `var`.
    names_are_defined_by word_definition: :name,     # : «double» 2 * ;
                         constant_definition: :name, # 46 constant «period»
                         variable_definition: :name  # var «position»

    # Drop each `needs`, because a solution that passes its tests has
    # already loaded every library it needs.
    imports "needs {{_}}" # «needs types/set»
  end
end
