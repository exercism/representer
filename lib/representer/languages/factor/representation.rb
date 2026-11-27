module Representer::Languages::Factor
  class Representation < Representer::Engine::Representation
    version 4

    # Rename words.
    names_are :symbol # «double»

    # Rename the words defined with `:` and `::`, the names in stack effects
    # and the names bound with `:>`.
    names_are_defined_by :inputs,          # : double ( «n» -- m ) 2 * ;
                         :outputs,         # : double ( n -- «m» ) 2 * ;
                         :var_binding,     # :: f ( a -- b ) a 1 + :> «c» c ;
                         definition: :name # : «double» ( n -- m ) 2 * ;

    # Drop each `USING:` and `USE:`, because a solution that passes its tests
    # has already made every vocabulary it needs available.
    imports "USING: {{...}} ;", # «USING: kernel math ;»
            "USE: {{...}}"      # «USE: io»
  end
end
