# This file declares the settings of F#'s representation.
# REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::FSharp
  class Representation < Representer::Engine::Representation
    version 9

    # Rename identifiers and the cases of active patterns.
    names_are :identifier,             # «count»
              :active_pattern_op_name  # (|«Even»|«Odd»|)

    # Rename the names of modules and namespaces.
    names_are_defined_by :module_name,  # module «Shop».«Counter»
                         :module_defn   # module «Counter» = ...

    # Rename the names of functions and values, their parameters, and the
    # variables in patterns and loops.
    names_are_defined_by :function_declaration_left,  # let «area» width height = ...
                         :named_pattern,              # let area «width» «height» = ...
                         :active_pattern,             # let (|«Even»|«Odd»|) n = ...
                         :as_pattern,                 # | (a, b) as «pair» -> ...
                         :type_check_pattern,         # | :? string as «text» -> ...
                         :for_expression,             # for «i» = 0 to 9 do ...
                         :declaration_expression      # use «reader» = ...

    # Rename the names of types, and of their cases, fields, members and
    # type variables.
    names_are_defined_by :union_type_case,                      # | «Circle» of float
                         :union_type_field,                     # | Circle of «radius»: float
                         :record_field,                         # { «Name»: string }
                         :enum_type_case,                       # | «Red» = 1
                         :property_or_ident,                    # member «this».«Area» = ...
                         :member_signature,                     # abstract member «Area»: float
                         :type_argument,                        # let first (xs: '«a» list) = ...
                         type_name: :type_name,                 # type «Shape» = ...
                         exception_definition: :exception_name  # exception «Oops» of string

    # Drop these imports, because a solution that passes its tests has already
    # opened every module it needs.
    imports "open {{...}}" # «open System»
  end
end
