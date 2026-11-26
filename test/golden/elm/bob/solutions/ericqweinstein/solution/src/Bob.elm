module Bob exposing (hey, isSpeech)


hey : String -> String
hey remark =
    let
        text =
            String.trim remark
    in
    if isQuestion text && isYelling text then
        "Calm down, I know what I'm doing!"

    else if isQuestion text then
        "Sure."

    else if isYelling text then
        "Whoa, chill out!"

    else if isSilence text then
        "Fine. Be that way!"

    else
        "Whatever."


isSpeech : String -> Bool
isSpeech =
    String.toList
        >> List.any Char.isAlpha


isQuestion : String -> Bool
isQuestion =
    String.endsWith "?"


isYelling : String -> Bool
isYelling remark =
    isSpeech remark && remark == String.toUpper remark


isSilence : String -> Bool
isSilence =
    String.isEmpty
