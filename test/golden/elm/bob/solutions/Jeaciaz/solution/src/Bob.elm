module Bob exposing (hey)

isShouting : String -> Bool
isShouting =
        String.filter Char.isAlpha 
        >> (\str -> String.length str > 0 && String.all Char.isUpper str)


getResponse : String -> String
getResponse remark =
    case (String.right 1 remark, isShouting remark) of
        ("", _) -> 
            "Fine. Be that way!"
        ("?", True) ->
            "Calm down, I know what I'm doing!"
        ("?", False) ->
            "Sure."
        (_, True) ->
            "Whoa, chill out!"
        _ ->
            "Whatever."

hey : String -> String
hey = String.trim >> getResponse