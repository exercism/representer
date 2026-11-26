module Bob exposing (hey)


isYelling : String -> Bool
isYelling s =
    (s == String.toUpper s) && String.any Char.isAlpha s


isQuestion : String -> Bool
isQuestion s =
    String.endsWith "?" (String.trim s)


isSilence : String -> Bool
isSilence s =
    String.isEmpty (String.trim s)


hey : String -> String
hey remark =
    case ( isYelling remark, isQuestion remark ) of
        ( True, True ) ->
            "Calm down, I know what I'm doing!"

        ( True, False ) ->
            "Whoa, chill out!"

        ( False, True ) ->
            "Sure."

        _ ->
            if isSilence remark then
                "Fine. Be that way!"

            else
                "Whatever."
