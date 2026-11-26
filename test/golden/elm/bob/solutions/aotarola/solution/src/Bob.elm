module Bob exposing (hey)

import Regex


letters : Regex.Regex
letters =
    Maybe.withDefault Regex.never <| Regex.fromString "[a-zA-z]"


whitespace : Regex.Regex
whitespace =
    Maybe.withDefault Regex.never <| Regex.fromString "[\\s]"


questionMark : Regex.Regex
questionMark =
    Maybe.withDefault Regex.never <| Regex.fromString ".*\\?$"


stripWhitespace : String -> String
stripWhitespace s =
    Regex.replace whitespace (\_ -> "") s


isSayingNothing : String -> Bool
isSayingNothing s =
    s
        |> stripWhitespace
        |> String.isEmpty


isAskingQuestion : String -> Bool
isAskingQuestion s =
    s
        |> stripWhitespace
        |> Regex.contains questionMark


isYelling : String -> Bool
isYelling s =
    Regex.contains letters s && s == String.toUpper s


isYelledQuestion : String -> Bool
isYelledQuestion s =
    isYelling s && isAskingQuestion s


hey : String -> String
hey remark =
    if isYelledQuestion remark then
        "Calm down, I know what I'm doing!"

    else if isYelling remark then
        "Whoa, chill out!"

    else if isAskingQuestion remark then
        "Sure."

    else if isSayingNothing remark then
        "Fine. Be that way!"

    else
        "Whatever."
