module Bob exposing (hey)

import String exposing (endsWith, toLower, toUpper, trim, words)


hey : String -> String
hey remark =
    let
        input =
            trim remark
    in
    if endsWith "?" input then
        if isYell input then
            "Calm down, I know what I'm doing!"

        else
            "Sure."

    else if input == "" then
        "Fine. Be that way!"

    else if isYell input then
        "Whoa, chill out!"

    else
        "Whatever."


isYell remark =
    remark == toUpper remark && remark /= toLower remark
