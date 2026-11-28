module Inspector::Languages::Odin::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the package, and the names of procedures, types, constants and
    # variables.
    names_are_defined_by :package_declaration,                     # package «leap»
                         procedure_declaration: :name,             # «is_leap» :: proc(year: int) -> bool { ... }
                         overloaded_procedure_declaration: :name,  # «area» :: proc{area_circle, area_square}
                         struct_declaration: :name,                # «Point» :: struct { x, y: int }
                         union_declaration: :name,                 # «Shape» :: union { Circle, Square }
                         enum_declaration: :name,                  # «Color» :: enum { Red, Blue }
                         bit_field_declaration: :name,             # «Flags» :: bit_field u8 { ... }
                         const_declaration: :name,                 # «MAX» :: 10
                         const_type_declaration: :name,            # «MAX» : int : 10
                         var_declaration: :name,                   # «count» : int
                         variable_declaration: :name,              # «count» := 0
                         assignment_statement: :name               # «a», «b» := f()

    # Rename parameters, results, fields, enum values and labels, and the
    # variables of loops and type switches.
    names_are_defined_by parameter: :name,               # proc(«a», «b»: int)
                         default_parameter: :name,       # proc(«n» := 1)
                         polymorphic_parameters: :name,  # struct($«N»: int)
                         constant_type: :name,           # proc(x: $«T»)
                         array_type: :name,              # proc(xs: [$«N»]int)
                         named_type: :name,              # proc() -> («n»: int, «ok»: bool)
                         default_type: :name,            # proc() -> («n» := 0)
                         field: :name,                   # Point :: struct { «x», «y»: int }
                         struct_member: :name,           # struct { «x»: int }
                         enum_member: :name,             # enum { «Red», «Blue» = 2 }
                         label_statement: :name,         # «outer»: for { ... }
                         for_statement: :name,           # for «x», «i» in xs { ... }
                         unary_expression: :name,        # for &«x» in xs { ... }
                         in_expression: :name            # switch «v» in shape { ... }

    # Drop these imports, because a solution that passes its tests has already
    # imported every package it needs.
    imports 'import "{{_}}"',        # «import "core:fmt"»
            'import {{...}} "{{_}}"' # «import str "core:strings"»
  end
end
