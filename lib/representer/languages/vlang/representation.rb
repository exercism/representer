module Representer::Languages::Vlang
  class Representation < Representer::Engine::Representation
    version 6

    # Rename every name.
    names_are :identifier # «count»

    # Rename the names of functions, methods, constants, globals, types and their
    # fields, enums and their values, and interfaces and their methods.
    names_are_defined_by function_declaration: :name,         # fn «area»(w int) int { ... }
                         static_method_declaration: :name,    # fn Point.«new»() Point { ... }
                         const_definition: :name,             # const «max_size» = 10
                         global_var_definition: :name,        # __global «count» = 0
                         type_declaration: :name,             # type «Shape» = Circle | Square
                         struct_declaration: :name,           # struct «Point» { ... }
                         struct_field_declaration: :name,     # struct Point { «x» int }
                         enum_declaration: :name,             # enum «Color» { ... }
                         enum_field_definition: :name,        # enum Color { «red» }
                         interface_declaration: :name,        # interface «Shape» { ... }
                         interface_method_definition: :name   # interface Shape { «area»() f64 }

    # Rename the names of receivers, parameters, generic types, variables
    # and labels.
    names_are_defined_by receiver: :name,                     # fn («p» Point) area() int { ... }
                         parameter_declaration: :name,        # fn area(«w» int) int { ... }
                         var_definition: :name                # for «i», «x» in xs { ... }
    names_are_defined_by :generic_parameter,                  # fn first[«T»](xs []T) T { ... }
                         :identifier_list,                    # «a», «b» := 1, 2
                         :mutable_identifier,                 # mut «total» := 0
                         :lambda_parameter,                   # xs.map(|«x»| x * 2)
                         :label_definition                    # «outer»: for { ... }

    # Drop the imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}}" # «import strings»

    # Parse a code pattern as a line of its own, because an import ends with
    # a line break.
    pattern_contexts "{{pattern}}\n" # «import strings»
  end
end
