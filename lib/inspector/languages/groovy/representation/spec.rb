module Inspector::Languages::Groovy::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers and the names of types.
    names_are :identifier,      # «count»
              :type_identifier  # «Counter»

    # Rename the names of types, and their type parameters.
    names_are_defined_by type_parameter: :name,              # class Box<«T»> { }
                         class_declaration: :name,           # class «Counter» { }
                         interface_declaration: :name,       # interface «Shape» { }
                         trait_declaration: :name,           # trait «Named» { }
                         enum_declaration: :name,            # enum «Color» { RED }
                         record_declaration: :name,          # record «Point»(int x, int y) { }
                         annotation_type_declaration: :name  # @interface «Marker» { }

    # Rename the names of methods and enum constants.
    names_are_defined_by method_declaration: :name,  # static int «area»(int width) { }
                         enum_constant: :name        # enum Color { «RED», «GREEN» }

    # Rename fields, properties, local variables, parameters and record
    # components.
    names_are_defined_by variable_declarator: :name,     # def «count» = 0, int «count» = 0
                         rest_declarator: :name,         # def (a, *«rest») = list
                         formal_parameter: :name,        # int area(int «width»)
                         closure_parameter: :name,       # { «x», «y» -> x + y }
                         catch_formal_parameter: :name,  # catch (Exception «error»)
                         record_component: :name         # record Point(int «x»)

    # Rename the variables of loops, `try` resources and lambdas, and labels.
    names_are_defined_by for_in_statement: :variable,     # for («item» in items)
                         resource: :name,                 # try (def «reader» = open())
                         lambda_expression: :parameters,  # «x» -> x * 2
                         labeled_statement: :label        # «outer»: for (a in b)

    # Drop these imports, because a solution that passes its tests has already
    # imported everything it needs.
    imports "import {{...}}",                # «import java.time.Year»
            "import {{...}}.*",              # «import java.time.*»
            "import {{...}} as {{_}}",       # «import java.time.Year as Y»
            "import static {{...}}",         # «import static java.lang.Math.abs»
            "import static {{...}}.*",       # «import static java.lang.Math.*»
            "import static {{...}} as {{_}}" # «import static java.lang.Math.abs as absolute»
  end
end
