module Rosetta::Languages::Awk::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename identifiers. AWK's own variables, such as `NR`, have a type of
    # their own, so they keep their names.
    names_are :identifier # «count»

    # Rename the names of functions and their parameters.
    names_are_defined_by :parameter_list,             # function area(«width», «height») { ... }
                         function_definition: :name   # function «area»(width, height) { ... }

    # Rename the variables and arrays that are assigned to, changed, read
    # into or filled by a builtin.
    names_are_defined_by assignment_expression: :left, # «total» = 0
                         update_expression: :operand,  # «count»++
                         subscript_expression: :array, # «seen»[$1] = 1
                         delete_statement: :target,    # delete «seen»
                         for_in_statement: :index,     # for («key» in seen) ...
                         getline_expression: :target,  # getline «line» < file
                         argument_list: :filled        # split($0, «parts», ",")

    # Drop these imports, because a solution that passes its tests has
    # already loaded every file and extension it needs.
    imports '@include "{{_}}"', # «@include "array-utils.awk"»
            '@load "{{_}}"'     # «@load "ordchr"»
  end
end
