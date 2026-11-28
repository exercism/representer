module Rosetta::Languages::GDScript::Representation
  class Spec < Rosetta::Engine::Representation
    version 9

    # Rename identifiers, and the names given in definitions.
    names_are :identifier, # «count»
              :name        # var «count» = 0

    # Rename the names of functions, classes, enums and signals.
    names_are_defined_by function_definition: :name,   # func «area»(width):
                         lambda: :name,                # func «double»(x): return x * 2
                         class_definition: :name,      # class «Counter»:
                         class_name_statement: :name,  # class_name «Counter»
                         enum_definition: :name,       # enum «Color» { RED, GREEN }
                         enumerator: :left,            # enum Color { «RED», «GREEN» }
                         signal_statement: :name       # signal «finished»

    # Rename variables, constants, parameters and the variables of loops.
    names_are_defined_by :parameters,                # func area(«width», «height»):
                         variable_statement: :name,  # var «total» = 0
                         const_statement: :name,     # const «LIMIT» = 5
                         default_parameter: :name,   # func greet(«name» = "you"):
                         for_statement: :left        # for «item» in items:
  end
end
