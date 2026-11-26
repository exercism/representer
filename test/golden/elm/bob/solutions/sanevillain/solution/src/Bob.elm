module Bob exposing (hey)

import Char
import String


hey : String -> String
hey remark =
    let
        shouting =
            is_shouting remark

        asking =
            is_asking_a_question remark

        nothing =
            is_saying_nothing remark
    in
    if shouting && asking then
        "Calm down, I know what I'm doing!"

    else if shouting then
        "Whoa, chill out!"

    else if asking then
        "Sure."

    else if nothing then
        "Fine. Be that way!"

    else
        "Whatever."


is_saying_nothing : String -> Basics.Bool
is_saying_nothing remark =
    String.isEmpty (String.trim remark)


is_asking_a_question : String -> Basics.Bool
is_asking_a_question remark =
    String.endsWith "?" (String.trim remark)


is_shouting : String -> Basics.Bool
is_shouting remark =
    let
        alpha =
            String.filter Char.isAlpha remark
    in
    String.all Char.isUpper alpha && not (String.isEmpty alpha)
