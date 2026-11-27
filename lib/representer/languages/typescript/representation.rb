# TypeScript's representation starts with every declaration in JavaScript's,
# and adds the names that TypeScript's types define.
module Representer::Languages::TypeScript
  class Representation < Representer::Languages::JavaScript::Representation
    version 10

    # Rename the names of types.
    names_are :type_identifier # «Shape»

    # Rename the names of classes, interfaces, types and enums, and their type
    # parameters.
    names_are_defined_by :infer_type,                        # T extends Array<infer «U»> ? U : never
                         abstract_class_declaration: :name,  # abstract class «Shape» { ... }
                         interface_declaration: :name,       # interface «Shape» { ... }
                         type_alias_declaration: :name,      # type «Pair» = [number, number]
                         enum_declaration: :name,            # enum «Color» { Red, Green }
                         type_parameter: :name               # class Box<«T»> { ... }

    # Rename the functions declared without a body.
    names_are_defined_by function_signature: :name # function «area»(width: number): number;

    # Rename the members of classes, interfaces and enums.
    names_are_defined_by :enum_body,                        # enum Color { «Red», «Green» }
                         public_field_definition: :name,    # private «count» = 0
                         property_signature: :name,         # interface Shape { «sides»: number }
                         method_signature: :name,           # interface Shape { «area»(): number }
                         abstract_method_signature: :name,  # abstract «area»(): number
                         enum_assignment: :name             # enum Color { «Red» = 1 }

    # Rename parameters, which have types, and the names in types.
    names_are_defined_by required_parameter: :pattern,  # function area(«width»: number)
                         optional_parameter: :pattern,  # function greet(«name»?: string)
                         index_signature: :name,        # { [«key»: string]: number }
                         type_predicate: :name,         # (x): «x» is string
                         mapped_type_clause: :name      # { [«K» in Keys]: number }
  end
end
