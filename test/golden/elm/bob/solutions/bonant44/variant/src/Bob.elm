module Bob exposing (hey)


hey : String -> String
hey remark =
    let
        s =
            String.trim remark

        isYell =
            isYelling s

        isQuestion =
            String.endsWith "?" s
    in
    if isQuestion || not isYell then
        "Sure."

    else if isQuestion && isYell then
        "Calm down, I know what I'm doing!"

    else if isYell then
        "Whoa, chill out!"

    else if String.isEmpty s then
        "Fine. Be that way!"

    else
        "Whatever."


isYelling : String -> Bool
isYelling s =
    let
        chars =
            s |> String.filter Char.isAlpha
    in
    if String.isEmpty chars then
        False

    else
        String.all Char.isUpper chars
