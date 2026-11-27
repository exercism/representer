module Representer::Languages::Cpp
  class Representation < Representer::Engine::Representation
    version 10

    # Rename identifiers, and the names of namespaces, types, fields and labels.
    names_are :identifier,            # «count»
              :namespace_identifier,  # «leap»::is_leap_year(y)
              :type_identifier,       # «Clock» c;
              :field_identifier,      # c.«hour»
              :statement_identifier   # goto «done»;

    # Rename the names of namespaces, types and macros.
    names_are_defined_by :nested_namespace_specifier,       # namespace «a»::«b» { ... }
                         namespace_definition: :name,       # namespace «leap» { ... }
                         class_specifier: :name,            # class «Clock» { ... };
                         struct_specifier: :name,           # struct «Point» { ... };
                         union_specifier: :name,            # union «Value» { ... };
                         enum_specifier: :name,             # enum class «Color» { Red };
                         alias_declaration: :name,          # using «Grid» = std::vector<int>;
                         type_definition: :declarator,      # typedef int «Score»;
                         preproc_def: :name,                # #define «SIZE» 8
                         preproc_function_def: :name        # #define «SQUARE»(x) ((x) * (x))

    # Rename the names of template parameters.
    names_are_defined_by :type_parameter_declaration,          # template <typename «T»>
                         :variadic_type_parameter_declaration  # template <typename... «Ts»>

    # Rename the names of functions, methods, fields and enumerators.
    names_are_defined_by function_declarator: :declarator,  # int «area»(int width)
                         field_declaration: :declarator,    # int «hour»;
                         enumerator: :name                  # enum Color { «Red», «Green» };

    # Rename variables and parameters, and the names inside pointer, reference
    # and array declarators.
    names_are_defined_by :reference_declarator,                        # const std::string& «name»
                         :structured_binding_declarator,               # auto [«key», «value»] = pair;
                         declaration: :declarator,                     # int «total»;
                         init_declarator: :declarator,                 # int «total» = 0;, int «a», «b»;
                         parameter_declaration: :declarator,           # int area(int «width»)
                         optional_parameter_declaration: :declarator,  # int f(int «n» = 1)
                         pointer_declarator: :declarator,              # int* «p»
                         array_declarator: :declarator                 # int «xs»[3]

    # Rename the variables of range loops, and labels.
    names_are_defined_by for_range_loop: :declarator,  # for (auto «x» : xs)
                         labeled_statement: :label     # «done»: return;

    # Drop these imports, because a solution that passes its tests has already
    # included every header and made every name it needs available.
    imports "#include {{...}}",          # «#include <string>», «#include "leap.h"»
            "using namespace {{...}};",  # «using namespace std;»
            "using {{...}};"             # «using std::string;»

    # Read a code pattern that doesn't parse on its own as a preprocessor
    # line, which ends at a line break, or else as a statement in a function.
    pattern_contexts "{{pattern}}\n",            # «#include <string>»
                     "void f() { {{pattern}} }"  # «if (a) b();»
  end
end
