module Bob exposing (hey)


hey : String -> String
hey remark =
    let
        hasCharacters = remark |> String.toList |> List.any Char.isAlpha
        isAskingQuestion = remark |> String.trim |> String.endsWith "?"
        isYelling = hasCharacters && remark == (String.toUpper remark)
        isSilent = 0 == (remark |> String.trim |> String.length)
    in
        if isYelling && isAskingQuestion then
            "Calm down, I know what I'm doing!"
        else if isYelling then
            "Whoa, chill out!"
        else if isAskingQuestion then
            "Sure."
        else if isSilent then
            "Fine. Be that way!"
        else 
            "Whatever."
