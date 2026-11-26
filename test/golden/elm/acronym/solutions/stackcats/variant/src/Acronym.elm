module Acronym exposing (abbreviate)


abbreviate : String -> String
abbreviate =
    String.toUpper
        >> String.replace "-" " "
        >> String.split " "
        >> List.map (String.left 2)
        >> String.concat
