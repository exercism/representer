module Representer::Languages::D
  class Representation < Representer::Engine::Representation
    version 6

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the names of modules, types and templates.
    names_are_defined_by :module_fqn,                        # module «leap»;
                         class_declaration: :name,           # class «Counter» { ... }
                         struct_declaration: :name,          # struct «Point» { ... }
                         union_declaration: :name,           # union «Value» { ... }
                         interface_declaration: :name,       # interface «Shape» { ... }
                         enum_declaration: :name,            # enum «Color» { red }
                         template_declaration: :name,        # template «Foo»(T) { ... }
                         mixin_template_declaration: :name,  # mixin template «Foo»(T) { ... }
                         alias_initializer: :name,           # alias «Grid» = int[][];
                         template_parameter: :name           # T twice(«T»)(T v)

    # Rename the names of functions, enum members and constants.
    names_are_defined_by function_declaration: :name,   # int «area»(int width)
                         enum_member: :name,            # enum Color { «red», «green» }
                         anonymous_enum_member: :name,  # enum { «A» = 1 }
                         manifest_declarator: :name     # enum «LIMIT» = 10;

    # Rename variables and parameters, including the parameters of function
    # literals.
    names_are_defined_by declarator: :name,           # int «a», «b» = 1;
                         auto_declaration: :variable, # auto «total» = 0;
                         parameter: :name,            # int area(int «width»), «x» => x * 2
                         foreach_type: :name,         # foreach («i», «c»; s)
                         catch_statement: :name,      # catch (Exception «e»)
                         if_condition: :name          # if (auto «p» = k in aa)

    # Rename labels.
    names_are_defined_by label: :name # «done»: return;

    # Drop these imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}};" # «import std.algorithm : map;»
  end
end
