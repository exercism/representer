module Rosetta::Languages::Unison::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename names, the type variables of a type, the names of record
    # fields, and the operations of an ability.
    names_are :regular_identifier, # «count»
              :type_argument,      # type Tree «a» = ...
              :field_name,         # type Point = { «x» : Nat }
              :constructor_name    # ability Emit a where «emit» : a -> ()

    # Rename the names of terms and their parameters, the parameters of
    # lambdas, the variables in patterns and the type variables.
    names_are_defined_by :term_definition,           # «area» «width» «height» = ...
                         :variable_pattern,          # Some «x» -> ...
                         :type_variable,             # f : «a» -> «a»
                         type_signature: :term_name, # «area» : Nat -> Nat -> Nat
                         literal_function: :param    # «x» -> x + 1

    # Rename the names of types and abilities, and of their constructors,
    # fields, operations and type variables.
    names_are_defined_by :type_name,                     # type «Shape» = ...
                         :type_constructor,              # type Tree «a» = ...
                         :ability_name,                  # ability «Emit» a where ...
                         :ability_declaration,           # ability Emit «a» where ...
                         type_declaration: :constructor, # type Shape = «Circle» Float
                         record_field: :name,            # type Point = { «x» : Nat }
                         constructor: :name              # ability Emit a where «emit» : a -> ()

    # Drop these imports, because a solution that passes its tests has already
    # imported every name it needs.
    imports "use {{...}}" # «use List map»
  end
end
