module Bob exposing (hey)

import Char exposing (isLower, isUpper)
import String as String



-- Manner of speech acts or commmunication


type Locution
    = Statement
    | Question
    | Yelling
    | YellQuest
    | Silence



-- Predicates


isQuestion : String -> Bool
isQuestion =
    String.endsWith "?"


isYelling : String -> Bool
isYelling msg =
    String.any isUpper msg && (not <| String.any isLower msg)



-- Classify a string as a Locution.


classify : String -> Locution
classify remark =
    let
        clean =
            String.trim remark

        question =
            isQuestion clean

        yelling =
            isYelling clean
    in
    if question && yelling then
        YellQuest

    else if yelling then
        Yelling

    else if question then
        Question

    else if String.isEmpty clean then
        Silence

    else
        Statement



-- Public API


hey : String -> String
hey remark =
    case classify remark of
        Statement ->
            "Whatever."

        Question ->
            "Sure."

        Yelling ->
            "Whoa, chill out!"

        YellQuest ->
            "Calm down, I know what I'm doing!"

        Silence ->
            "Fine. Be that way!"
