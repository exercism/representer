module Bob exposing (hey)

import Char
import String


hey : String -> String
hey remark =
    let
        trimmed =
            String.trim remark
    in
    if String.isEmpty trimmed then
        "Fine. Be that way!"

    else
        let
            isUpper char =
                if not (Char.isAlpha char) then
                    True

                else
                    Char.isUpper char

            isYelling =
                String.all isUpper trimmed && String.any Char.isAlpha trimmed

            isQuestion =
                String.endsWith "?" trimmed
        in
        case ( isYelling, isQuestion ) of
            ( True, True ) ->
                "Calm down, I know what I'm doing!"

            ( True, False ) ->
                "Whoa, chill out!"

            ( False, True ) ->
                "Sure."

            ( False, False ) ->
                "Whatever."
