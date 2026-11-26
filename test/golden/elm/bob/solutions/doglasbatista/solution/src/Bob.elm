module Bob exposing (hey)

import String exposing (trim)


type Statement
    = Default
    | YellingQuestion
    | Yelling
    | Question
    | Nothing


hasWords : String -> Bool
hasWords remark =
    String.any Char.isAlpha remark


isYelling : String -> Bool
isYelling remark =
    String.toUpper remark == remark


isQuestion : String -> Bool
isQuestion remark =
    String.endsWith "?" remark


isEmpty : String -> Bool
isEmpty remark =
    String.isEmpty remark


statement : String -> Statement
statement remark =
    if isEmpty remark then
        Nothing

    else if isQuestion remark && isYelling remark && hasWords remark then
        YellingQuestion

    else if isQuestion remark then
        Question

    else if isYelling remark && hasWords remark then
        Yelling

    else
        Default


hey : String -> String
hey remark =
    case statement (String.trim remark) of
        YellingQuestion ->
            "Calm down, I know what I'm doing!"

        Question ->
            "Sure."

        Yelling ->
            "Whoa, chill out!"

        Nothing ->
            "Fine. Be that way!"

        _ ->
            "Whatever."
