module Bob exposing (hey)


hey : String -> String
hey remark =
    let
        trimmedRemark =
            String.trim remark
    in
    let
        isAlpha =
            String.any Char.isAlpha trimmedRemark
    in
    let
        isYelling =
            trimmedRemark == String.toUpper trimmedRemark && isAlpha
    in
    let
        isQuestion =
            String.endsWith "?" trimmedRemark
    in
    let
        isSilence =
            String.isEmpty trimmedRemark
    in
    if isYelling && isQuestion then
        "Calm down, I know what I'm doing!"

    else if isQuestion then
        "Sure."

    else if isYelling then
        "Whoa, chill out!"

    else if isSilence then
        "Fine. Be that way!"

    else
        "Whatever."
