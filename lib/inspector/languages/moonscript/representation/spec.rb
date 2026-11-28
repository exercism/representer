module Inspector::Languages::Moonscript::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers and the names of fields.
    names_are :identifier,         # «count»
              :property_identifier # @«count», a.«count», { «count»: 0 }

    # Rename the variables and fields that are assigned to, including the
    # fields set on `self`, a class or a table, the keys of tables and the
    # properties of classes.
    names_are_defined_by :variable_list,          # local «total» = 0
                         dot_index: :name,        # M.«area» = (width) -> ...
                         with_dot_index: :name,   # with t then .«count» = 0
                         self_field: :name,       # @«count» = 0
                         class_field: :name,      # @@«total» = 0
                         pair: :key,              # { «count»: 0 }
                         class_declaration: :name # class «Counter»

    # Rename parameters, the variables of loops, and the names in a table
    # that is unpacked.
    names_are_defined_by :parameter,               # («width», height) -> ...
                         :name_list,               # for «key», «value» in pairs t
                         :table_pattern,           # {«first», «second»} = pair
                         default_parameter: :name, # («height» = 1) -> ...
                         pair_pattern: :value,     # {count: «total»} = totals
                         for_expression: :name,    # for «i» = 1, 10
                         for_clause: :name         # [i for «i» = 1, 10]

    # Drop these imports, because a solution that passes its tests has
    # already loaded every module it needs.
    imports 'import {{...}} from require "{{_}}"', # «import fold from require 'moon'»
            'local {{_}} = require "{{_}}"',       # «local List = require 'pl.List'»
            '{{_}} = require "{{_}}"'              # «List = require 'pl.List'»
  end
end
