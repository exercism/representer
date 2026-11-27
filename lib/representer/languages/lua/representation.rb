module Representer::Languages::Lua
  class Representation < Representer::Engine::Representation
    version 6

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the variables and table fields that are assigned to, including
    # the functions set on a table, and local functions.
    names_are_defined_by variable_list: :name,        # local «total» = 0
                         dot_index_expression: :name, # M.«area» = function(width) ... end
                         function_declaration: :name  # local function «area»(width) ... end

    # Rename parameters, the variables of loops, labels, and the names of
    # fields in a table constructor.
    names_are_defined_by :parameters,               # function(«width», «height») ... end
                         :label_statement,          # ::«continue»::
                         for_numeric_clause: :name, # for «i» = 1, 10 do ... end
                         field: :name               # { «count» = 0 }

    # Drop these imports, because a solution that passes its tests has
    # already loaded every module it needs.
    imports 'local {{...}} = require("{{...}}")', # «local inspect = require("inspect")»
            'require("{{...}}")'                  # «require("strict")»
  end
end
