module Inspector::Languages::Elm::Representation
  class Spec < Inspector::Engine::Representation
    version 9

    # Rename names that start with a lower case letter, and names that
    # start with a capital.
    names_are :lower_case_identifier,  # «count»
              :upper_case_identifier   # «Shape»

    # Rename the names of the module, functions, values and ports, their
    # parameters, and the variables in patterns.
    names_are_defined_by :module_name,                # module «Leap» exposing (isLeapYear)
                         :function_declaration_left,  # «area» width height = ...
                         :lower_pattern,              # area «width» «height» = ...
                         port_annotation: :name       # port «send» : String -> Cmd msg

    # Rename the names of types, and of their constructors, fields and type
    # variables.
    names_are_defined_by :lower_type_name,               # type Tree «a» = ...
                         :type_variable,                 # area : «a» -> «a»
                         type_declaration: :name,        # type «Shape» = ...
                         type_alias_declaration: :name,  # type alias «Point» = ...
                         union_variant: :name,           # type Shape = «Circle» Float
                         field_type: :name,              # type alias Point = { «x» : Int }
                         field: :name                    # { «x» = 1 }

    # Drop these imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports "import {{...}}",                             # «import Dict»
            "import {{...}} as {{_}}",                    # «import Dict as D»
            "import {{...}} exposing ({{...}})",          # «import Dict exposing (Dict)»
            "import {{...}} exposing (..)",               # «import Dict exposing (..)»
            "import {{...}} as {{_}} exposing ({{...}})", # «import Dict as D exposing (Dict)»
            "import {{...}} as {{_}} exposing (..)"       # «import Dict as D exposing (..)»
  end
end
