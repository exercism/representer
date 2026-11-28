module Rosetta::Languages::Futhark::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename values, functions, parameters, types, record fields, modules,
    # constructors and the operators the solution defines.
    names_are :identifier,  # «count»
              :constructor, # «#red»
              :operator     # a «+++» b

    # Rename the names of values and functions, their parameters, and the
    # variables in patterns and loops.
    names_are_defined_by :tuple_pattern,                 # let («a», «b») = pair
                         :record_pattern,                # let {«a» = «b»} = r
                         value_declaration: :name,       # def «area» «w» = ...
                         value_specification: :name,     # val «area» : i32 -> i32
                         binding: :name,                 # let «area» «w» = ...
                         lambda: :parameter,             # \«x» -> x + 1
                         typed_pattern: :pattern,        # («x»: i32)
                         constructor_pattern: :name,     # case #some «x» -> x
                         case: :pattern,                 # case «x» -> x
                         loop_expression: :pattern,      # loop «acc» = 0 for ...
                         for_upto: :name,                # for «i» < n do ...
                         for_in: :pattern                # for «x» in xs do ...

    # Rename the names of types, and of their constructors, record fields,
    # type parameters and sizes.
    names_are_defined_by :type_parameter,                # type tree '«a» = ...
                         :size_parameter,                # def f [«n»] (xs: [n]i32) = ...
                         :existential_type,              # ?[«n»].[n]i32
                         :function_type,                 # («n»: i64) -> [n]i32
                         :variant,                       # type color = «#red» | «#green»
                         type_declaration: :name,        # type «point» = ...
                         record_type: :name,             # {«x»: i32}
                         record_field: :name             # {«x» = 1}

    # Rename the names of modules and module types.
    names_are_defined_by module_declaration: :name,      # module «m» = ...
                         module_parameter: :name,        # module m («p»: integral) = ...
                         module_type_declaration: :name  # module type «s» = ...

    # Drop the imports and opens, because a solution that passes its tests
    # has already loaded every library and opened every module it needs.
    imports 'import "{{_}}"', # «import "lib/github.com/diku-dk/sorts/merge_sort"»
            "open {{...}}"    # «open i32»
  end
end
