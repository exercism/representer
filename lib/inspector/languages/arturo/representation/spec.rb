module Inspector::Languages::Arturo::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename words, and the types that the solution defines.
    names_are :identifier                # «total»
    names_are :type, without_prefix: ":" # to :«clock» [1 2]

    # Rename the names that labels, parameters, literal words, iterators and
    # `define` give.
    names_are_defined_by :destructuring_label, # [«a» «b»]: f x
                         :literal,             # loop xs '«x» [...]
                         :loop_variables,      # loop xs [«a» «b»] [...]
                         :type_definition,     # define :«robot» [...]
                         label: :name,         # «total»: 0
                         parameter: :name      # function [«x» :integer][...]

    # Drop each `import`, because a solution that passes its tests has
    # already loaded every package it needs.
    imports "import {{_}}!", # «import {unitt}!»
            "import {{_}}"   # «import 'unitt»
  end
end
