module Bob exposing (..)


hey : String -> String
hey message =
    let
        alphaOnly =
            String.filter Char.isAlpha message

        trimmed =
            String.trim message

        isEmpty =
            String.isEmpty trimmed

        isQuestion =
            String.endsWith "?" trimmed

        isForceful =
            not (String.isEmpty alphaOnly) && String.all Char.isUpper alphaOnly
    in
    case ( isEmpty, isQuestion, isForceful ) of
        ( True, _, _ ) ->
            "Fine. Be that way!"

        ( False, True, False ) ->
            "Sure."

        ( False, False, True ) ->
            "Whoa, chill out!"

        ( False, True, True ) ->
            "Calm down, I know what I'm doing!"

        _ ->
            "Whatever."
