module Representer::Languages::C::Representation
  class Spec < Representer::Engine::Representation
    version 6

    # Rename identifiers, and the names of types, fields and labels.
    names_are :identifier,           # «count»
              :type_identifier,      # «point_t» p;
              :field_identifier,     # p.«x»
              :statement_identifier  # goto «done»;

    # Rename the names of types and macros.
    names_are_defined_by struct_specifier: :name,       # struct «point» { int x; };
                         union_specifier: :name,        # union «value» { int i; };
                         enum_specifier: :name,         # enum «color» { RED };
                         type_definition: :declarator,  # typedef int «score»;
                         preproc_def: :name,            # #define «SIZE» 8
                         preproc_function_def: :name    # #define «SQUARE»(x) ((x) * (x))

    # Rename the names of functions, fields and enumerators.
    names_are_defined_by function_declarator: :declarator,  # int «area»(int width)
                         field_declaration: :declarator,    # struct point { int «x», «y»; };
                         enumerator: :name                  # enum color { «RED», «GREEN» };

    # Rename variables and parameters, and the names inside pointer and array
    # declarators.
    names_are_defined_by declaration: :declarator,            # int «a», «b»;
                         init_declarator: :declarator,        # int «total» = 0;
                         parameter_declaration: :declarator,  # int area(int «width»)
                         pointer_declarator: :declarator,     # int *«p»;, int (*«f»)(int);
                         array_declarator: :declarator        # int «xs»[3];

    # Rename labels.
    names_are_defined_by labeled_statement: :label # «done»: return;

    # Drop these imports, because a solution that passes its tests has already
    # included every header it needs.
    imports "#include {{...}}" # «#include <stdbool.h>», «#include "leap.h"»

    # Read a code pattern that doesn't parse on its own as a preprocessor
    # line, which ends at a line break, or else as a statement in a function.
    pattern_contexts "{{pattern}}\n",            # «#include <stdio.h>»
                     "void f() { {{pattern}} }"  # «if (a) b();»
  end
end
