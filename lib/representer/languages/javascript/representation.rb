module Representer::Languages::Javascript
  class Representation < Representer::Engine::Representation
    version 9

    # Rename identifiers, labels and the names of properties, including
    # private ones and the shorthand ones in objects and patterns.
    names_are :identifier,                             # «count»
              :statement_identifier,                   # «outer»: for (...)
              :property_identifier,                    # this.«count»
              :private_property_identifier,            # this.«#count»
              :shorthand_property_identifier,          # { «count» }
              :shorthand_property_identifier_pattern   # const { «count» } = totals

    # Rename the names of functions and classes.
    names_are_defined_by function_declaration: :name,            # function «area»(width) { ... }
                         generator_function_declaration: :name,  # function* «ids»() { ... }
                         function_expression: :name,             # const f = function «area»() { ... }
                         generator_function: :name,              # const f = function* «ids»() { ... }
                         class_declaration: :name,               # class «Counter» { ... }
                         class: :name                            # const C = class «Counter» { ... }

    # Rename the names of methods and fields, and of the properties set on
    # `this`.
    names_are_defined_by method_definition: :name,     # «area»() { ... }
                         field_definition: :property,  # «#count» = 0;
                         this_property: :property      # this.«count» = 0

    # Rename variables and parameters, including the ones in patterns.
    names_are_defined_by :formal_parameters,                # function area(«width», «height»)
                         :rest_pattern,                     # function sum(...«numbers»)
                         :array_pattern,                    # const [«first», «second»] = pair
                         :object_pattern,                   # const { «count» } = totals
                         variable_declarator: :name,        # const «total» = price * 2
                         arrow_function: :parameter,        # xs.map(«x» => x * 2)
                         assignment_pattern: :left,         # function greet(«name» = "you")
                         object_assignment_pattern: :left,  # const { «count» = 0 } = totals
                         pair_pattern: :value,              # const { count: «total» } = totals
                         assignment_expression: :left       # «total» = price * 2

    # Rename the variables of loops and `catch`, and labels.
    names_are_defined_by for_in_statement: :left,   # for (const «item» of items)
                         catch_clause: :parameter,  # catch («error»)
                         labeled_statement: :label  # «outer»: for (...)

    # Drop these imports and export lists, because a solution that passes its
    # tests has already made every name it needs available. Keep an import
    # with no names, such as `import "./setup"`, because it runs code.
    # representation/normalise.rb drops `require` and `module.exports`.
    imports 'import {{...}} from "{{...}}";',  # «import { sum } from "./sum";»
            "export { {{...}} };"              # «export { sum };»
  end
end
