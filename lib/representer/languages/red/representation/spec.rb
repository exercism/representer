module Representer::Languages::Red::Representation
  class Spec < Representer::Engine::Representation
    version 4

    # Rename words.
    names_are :word # «total»

    # Rename the words that set words, function specs and loops define.
    names_are_defined_by :set_word,       # «total»: 0
                         :function_spec,  # f: func [«a» /local «b»] [...]
                         :loop_variable   # foreach «c» "ab" [...]
  end
end
