module Bob exposing (hey)


hey : String -> String
hey remark =
    let 
        rmk = String.trim remark

        isAQuestion : String -> Bool
        isAQuestion str =
            String.endsWith "?" str

        isYell : String -> Bool
        isYell str =
            (str |> String.filter Char.isAlpha |> String.all Char.isUpper) && String.any Char.isAlpha str

        isEmpty : String -> Bool
        isEmpty str =
            str |> String.isEmpty
    in
    if isAQuestion rmk && isYell rmk then
        "Calm down, I know what I'm doing!"
    else if isAQuestion rmk then
        "Sure."
    else if isYell rmk then
        "Whoa, chill out!"
    else if isEmpty rmk then
        "Fine. Be that way!"
    else
        "Whatever."

