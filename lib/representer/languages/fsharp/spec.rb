# This file declares how the representer reads F#. REPRESENTER_DSL.md
# explains each declaration, and the other files in this folder hold F#'s
# stages.
module Representer::Languages::FSharp
  class Spec < Representer::Engine::Language
    tracks "fsharp"
    version 9
    grammar "fsharp"
    extensions ".fs", ".fsx"

    # Keep the whole text of these, because the grammar only gives their
    # quotes and marks.
    text_nodes :float,                 # «1.5»
               :verbatim_string,       # «@"a\b"»
               :triple_quoted_string,  # «"""a"""»
               :bytearray              # «"ab"B»

    # Keep the text between the children of these, because the grammar
    # leaves out the text of a string.
    text_between_children :string,        # "«a»"
                          :format_string  # $"«a»{x}«b»"

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
    imports "open {{module}}" # «open System»
  end
end
