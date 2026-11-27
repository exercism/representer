module Representer::Languages::Typescript
  class Representation < Representer::Engine::Representation
    version 9

    # Rename identifiers, property names, labels and type names. Leave out
    # shorthand properties (`{ a }`), because their name is also a property's
    # name.
    names_are :identifier,                   # «count»
              :property_identifier,          # this.«count»
              :private_property_identifier,  # this.«#count»
              :statement_identifier,         # «outer»: for (...)
              :type_identifier               # «Shape»

    # Rename the names of classes, interfaces, types and enums, and their type
    # parameters.
    names_are_defined_by :infer_type,                        # T extends Array<infer «U»> ? U : never
                         class_declaration: :name,           # class «Counter» { ... }
                         abstract_class_declaration: :name,  # abstract class «Shape» { ... }
                         interface_declaration: :name,       # interface «Shape» { ... }
                         type_alias_declaration: :name,      # type «Pair» = [number, number]
                         enum_declaration: :name,            # enum «Color» { Red, Green }
                         type_parameter: :name               # class Box<«T»> { ... }

    # Rename the names of functions.
    names_are_defined_by function_declaration: :name,            # function «area»(width: number) { ... }
                         generator_function_declaration: :name,  # function* «count»() { ... }
                         function_expression: :name,             # const f = function «area»() { ... }
                         function_signature: :name               # function «area»(width: number): number;

    # Rename the members of classes, interfaces and enums.
    names_are_defined_by :enum_body,                        # enum Color { «Red», «Green» }
                         method_definition: :name,          # «area»() { ... }
                         public_field_definition: :name,    # private «count» = 0
                         property_signature: :name,         # interface Shape { «sides»: number }
                         method_signature: :name,           # interface Shape { «area»(): number }
                         abstract_method_signature: :name,  # abstract «area»(): number
                         enum_assignment: :name             # enum Color { «Red» = 1 }

    # Rename variables and parameters, including the ones in types.
    names_are_defined_by :rest_pattern,                 # function sum(...«numbers»: number[])
                         :array_pattern,                # const [«first», «second»] = pair
                         variable_declarator: :name,    # const «total» = price * 2
                         assignment_expression: :left,  # «total» = price * 2
                         required_parameter: :pattern,  # function area(«width»: number)
                         optional_parameter: :pattern,  # function greet(«name»?: string)
                         arrow_function: :parameter,    # xs.map(«x» => x * 2)
                         assignment_pattern: :left,     # const [«first» = 0] = list
                         for_in_statement: :left,       # for (const «item» of items)
                         catch_clause: :parameter,      # catch («error»)
                         labeled_statement: :label,     # «outer»: for (...)
                         index_signature: :name,        # { [«key»: string]: number }
                         type_predicate: :name,         # (x): «x» is string
                         mapped_type_clause: :name      # { [«K» in Keys]: number }

    # Drop these imports and export lists, because a solution that passes its
    # tests has already loaded everything it needs, and exports what the tests
    # use. Keep an import with no names, because it runs the file it imports.
    imports 'import {{...}} from "{{...}}"',  # «import { sum } from "./sum"»
            "export { {{...}} }"              # «export { sum }»
  end
end
