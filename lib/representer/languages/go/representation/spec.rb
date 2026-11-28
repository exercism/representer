module Representer::Languages::Go::Representation
  class Spec < Representer::Engine::Representation
    version 11

    # Rename identifiers, and the names of fields, types and labels.
    names_are :identifier,        # «count»
              :field_identifier,  # p.«x»
              :type_identifier,   # var p «Point»
              :label_name         # break «outer»

    # Rename the names of types and functions.
    names_are_defined_by type_spec: :name,             # type «Point» struct { ... }
                         type_alias: :name,            # type «Name» = string
                         function_declaration: :name,  # func «Area»(w, h int) int { ... }
                         method_declaration: :name,    # func (p Point) «Area»() int { ... }
                         method_elem: :name            # type Shape interface { «Area»() int }

    # Rename the names of variables, constants, fields, parameters and labels.
    names_are_defined_by :identifier_list,                       # var «a», «b» int
                         variadic_parameter_declaration: :name,  # func Sum(«xs» ...int) int
                         labeled_statement: :label               # «outer»: for { ... }

    # Drop these imports, because a solution that passes its tests has already
    # imported every package it needs. Keep an import of `_`, because it runs
    # the package's code.
    imports 'import "{{_}}"',       # «import "strings"»
            'import {{_}} "{{_}}"', # «import s "strings"»
            'import . "{{_}}"'      # «import . "strings"»
  end
end
