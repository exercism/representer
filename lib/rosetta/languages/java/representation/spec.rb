module Rosetta::Languages::Java::Representation
  class Spec < Rosetta::Engine::Representation
    version 9

    # Rename identifiers and the names of types.
    names_are :identifier,      # «count»
              :type_identifier  # «Counter»

    # Rename the names of types, and their type parameters.
    names_are_defined_by :type_parameter,               # class Box<«T»> { ... }
                         class_declaration: :name,      # class «Counter» { ... }
                         interface_declaration: :name,  # interface «Shape» { ... }
                         enum_declaration: :name,       # enum «Color» { RED }
                         record_declaration: :name      # record «Point»(int x, int y) { }

    # Rename the names of methods and enum constants.
    names_are_defined_by method_declaration: :name,  # int «area»(int width) { ... }
                         enum_constant: :name        # enum Color { «RED», «GREEN» }

    # Rename fields, local variables, parameters and record components.
    names_are_defined_by :inferred_parameters,            # («a», «b») -> a + b
                         variable_declarator: :name,      # private int «count» = 0;
                         formal_parameter: :name,         # int area(int «width»), record Point(int «x»)
                         lambda_expression: :parameters,  # «x» -> x * 2
                         catch_formal_parameter: :name    # catch (Exception «error»)

    # Rename the variables of loops, `try` resources and `instanceof`, and labels.
    names_are_defined_by :labeled_statement,             # «outer»: for (...)
                         enhanced_for_statement: :name,  # for (int «item» : items)
                         resource: :name,                # try (var «reader» = open())
                         instanceof_expression: :name    # if (shape instanceof Circle «circle»)

    # Drop these imports, because a solution that passes its tests has already
    # imported everything it needs.
    imports "import {{...}};" # «import java.util.List;»

    # Read a code pattern that doesn't parse on its own as a statement in a method.
    pattern_contexts "class A { void f() { {{pattern}} } }" # «if (a) b();»
  end
end
