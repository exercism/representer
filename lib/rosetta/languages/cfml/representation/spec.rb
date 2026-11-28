module Rosetta::Languages::CFML::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename identifiers and the names of properties and struct keys.
    names_are :identifier,         # «count»
              :property_identifier # arguments.«count»

    # Rename the names of functions, including the methods of components.
    names_are_defined_by function_declaration: :name, # function «area»(width) { ... }
                         function_expression: :name   # f = function «area»() { ... }

    # Rename variables and parameters, including the variables set on the
    # `this`, `variables` and `local` scopes.
    names_are_defined_by parameter: :name,             # function area(«width», «height» = 1)
                         variable_declarator: :name,   # var «total» = price * 2
                         assignment_expression: :left, # «total» = price * 2
                         scope_property: :property     # local.«total» = price * 2

    # Rename the variables of loops and `catch`.
    names_are_defined_by for_in_statement: :left,  # for (var «item» in items)
                         catch_clause: :parameter  # catch (any «error»)

    # Drop the imports, because a solution that passes its tests has already
    # made every component it needs available.
    imports "import {{...}};" # «import com.example.Shape;»
  end
end
