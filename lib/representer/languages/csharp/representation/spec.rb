module Representer::Languages::CSharp::Representation
  class Spec < Representer::Engine::Representation
    version 11

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the names of namespaces and types.
    names_are_defined_by namespace_declaration: :name,              # namespace «Shop» { ... }
                         file_scoped_namespace_declaration: :name,  # namespace «Shop»;
                         class_declaration: :name,                  # class «Counter» { ... }
                         struct_declaration: :name,                 # struct «Point» { ... }
                         interface_declaration: :name,              # interface «IShape» { ... }
                         record_declaration: :name,                 # record «Point»(int X, int Y);
                         enum_declaration: :name,                   # enum «Color» { Red, Green }
                         delegate_declaration: :name,               # delegate int «Apply»(int x);
                         type_parameter: :name                      # class Box<«T»> { ... }

    # Rename the names of members.
    names_are_defined_by method_declaration: :name,        # int «Area»(int width) { ... }
                         local_function_statement: :name,  # int «Square»(int x) => x * x;
                         property_declaration: :name,      # int «Count» { get; set; }
                         event_declaration: :name,         # event Action «Changed» { add { } remove { } }
                         enum_member_declaration: :name    # enum Color { «Red», «Green» }

    # Rename fields, local variables and parameters.
    names_are_defined_by :tuple_pattern,              # var («first», «second») = pair;
                         variable_declarator: :name,  # int «total» = price * 2;
                         parameter: :name,            # int Area(int «width», int «height»)
                         tuple_element: :name         # (int «count», string «name») pair

    # Rename the variables of loops, `catch`, patterns and `out var`.
    names_are_defined_by :parenthesized_variable_designation,  # pair switch { var («a», «b») => a }
                         foreach_statement: :left,             # foreach (var «item» in items)
                         catch_declaration: :name,             # catch (Exception «error»)
                         declaration_pattern: :name,           # if (shape is Circle «circle»), if (pair is var «both»)
                         recursive_pattern: :name,             # if (point is { X: 0 } «origin»)
                         list_pattern: :name,                  # if (xs is [1, 2] «pair»)
                         declaration_expression: :name         # int.TryParse(text, out var «number»)

    # Rename the variables of queries.
    names_are_defined_by from_clause: :name,  # from «word» in words
                         let_clause: :name,   # let «total» = a + b
                         join_clause: :name   # join «order» in orders on ...

    # Drop these imports, because a solution that passes its tests has already
    # made every namespace it needs available.
    imports "using {{...}};",      # «using System.Linq;»
            "using {{_}} = {{_}};" # «using Point = (int Row, int Col);»

    # Read a code pattern that doesn't parse on its own as a value, or else as
    # a statement in a method.
    pattern_contexts "object x = {{pattern}};",               # «a == true»
                     "class A { void F() { {{pattern}} } }"   # «if (a) b();»
  end
end
