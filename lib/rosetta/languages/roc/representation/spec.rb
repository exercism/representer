module Rosetta::Languages::Roc::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename names that start with a lower case letter, and names that
    # start with a capital.
    names_are :identifier,     # «count»
              :field_name,     # { «real»: 1.0 }
              :bound_variable, # List(«a»)
              :concrete_type,  # «Clock»
              :module,         # «Clock».create(1, 2)
              :tag_name        # [«Red», «Green»]

    # Rename the names of values and functions, their parameters, and the
    # variables in patterns.
    names_are_defined_by :identifier_pattern,    # «area» = |«width», «height»| width * height
                         :annotation_pre_colon,  # «area» : U64, U64 -> U64
                         :as_pattern,            # [_, ..] as «list»
                         :spread_pattern,        # [first, ..«rest»]
                         var_declaration: :name  # var «$total» = 0

    # Rename the names of types, and of their fields, tags and type
    # variables.
    names_are_defined_by :type_name,            # «Clock» := { hours : U8 }
                         :type_variable,        # List(«a») -> «a»
                         :tag_type,             # [«Red», «Green»(U8)]
                         :record_field_type,    # { «hours» : U8 }
                         :record_field_expr,    # { «hours»: 1 }
                         :record_field_pattern  # { «hours», minutes } = clock

    # Drop these imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}}" # «import Helpers exposing [shout]»
  end
end
