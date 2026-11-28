module Rosetta::Languages::Rescript::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename values, record fields, types, type variables, constructors,
    # polymorphic variants and modules.
    names_are :value_identifier,     # «count»
              :property_identifier,  # p.«width»
              :type_identifier,      # «shape»
              :type_variable_name,   # array<«'a»>
              :variant_identifier,   # «Circle»(1.0)
              :polyvar_identifier,   # «#red»
              :module_identifier     # «Counter».reset

    # Rename the names of values and functions, and their parameters and
    # labels.
    names_are_defined_by let_binding: :pattern,          # let «area» = ...
                         labeled_parameter: :name,       # let area = (~«width») => ...
                         external_declaration: :name     # external «area»: int => int = "area"
    names_are_defined_by :parameter,                     # let area = («width», «height») => ...
                         :abstract_type                  # let f = (type «t», x: t) => ...

    # Rename the variables in patterns and loops.
    names_are_defined_by switch_match: :pattern,         # | «x» => x
                         record_pattern_field: :pattern, # let {width: «w»} = shape
                         for_expression: :variable       # for «i» in 0 to 9 { ... }
    names_are_defined_by :formal_parameters,             # | Some(«x») => x
                         :tuple_item_pattern,            # let («a», «b») = pair
                         :array_pattern,                 # | [«a», «b»] => a
                         :list_pattern,                  # | list{«head», ...tail} => head
                         :spread_pattern,                # | list{head, ...«tail»} => tail
                         :or_pattern,                    # | «x» | «x» => x
                         :as_aliasing,                   # | Some(_) as «x» => x
                         :dict_pattern_entry,            # | dict{"a": «a»} => a
                         :exception_pattern,             # | exception «e» => e
                         :lazy_pattern                   # | lazy «x» => x

    # Rename the names of types, and of their constructors, fields, type
    # variables and polymorphic variants.
    names_are_defined_by type_binding: :name,            # type «shape» = ...
                         exception_declaration: :name    # exception «Invalid»(string)
    names_are_defined_by :type_variable,                 # let first = (xs: array<«'a»>) => ...
                         :variant_declaration,           # type shape = «Circle»(float)
                         :record_type_field,             # type point = {«x»: int}
                         :polyvar_declaration            # type colour = [«#red» | «#blue»]

    # Rename the names of modules and functor parameters.
    names_are_defined_by module_binding: :name           # module «Counter» = { ... }
    names_are_defined_by :functor_parameter              # module Make = («X»: S) => { ... }

    # Drop the opens, because a solution that passes its tests has already
    # opened every module it needs.
    imports "open {{...}}" # «open Belt»
  end
end
