# This file declares how the representer reads C#. REPRESENTER_DSL.md
# explains each declaration, and the other files in this folder hold C#'s
# stages.
module Representer::Languages::CSharp
  class Spec < Representer::Engine::Language
    tracks "csharp"
    version 10
    grammar "c_sharp"
    extensions ".cs"

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
    imports "using {{namespace}};" # «using System.Linq;»

    # Read a code pattern that doesn't parse on its own as a value.
    pattern_contexts "object x = ...;"
  end
end
