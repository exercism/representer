module Bob exposing (hey)


isYell : String -> Bool
isYell remark =
    let
        uppercase : Char -> Bool
        uppercase c =
            if Char.isAlpha c then
                Char.isUpper c

            else
                True
    in
    String.any Char.isAlpha remark && String.all uppercase remark


isSilence : String -> Bool
isSilence =
    String.isEmpty


isQuestion : String -> Bool
isQuestion =
    String.endsWith "?"


hey : String -> String
hey remark =
    let
        trimmed =
            String.trim remark
    in
    case ( isSilence trimmed, isQuestion trimmed, isYell trimmed ) of
        ( True, _, _ ) ->
            "Fine. Be that way!"

        ( False, True, False ) ->
            "Sure."

        ( False, True, True ) ->
            "Calm down, I know what I'm doing!"

        ( False, False, True ) ->
            "Whoa, chill out!"

        ( False, False, False ) ->
            "Whatever."
