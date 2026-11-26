module Bob exposing (hey)

import Char exposing (isAlpha, isUpper)
import String exposing (all, any, endsWith, filter, isEmpty, trim, trimRight)


hey : String -> String
hey remark =
    if isYelling remark && isQuestion remark then
        "Calm down, I know what I'm doing!"

    else if isYelling remark then
        "Whoa, chill out!"

    else if isQuestion remark then
        "Sure."

    else if isSilence remark then
        "Fine. Be that way!"

    else
        "Whatever."


isYelling : String -> Bool
isYelling remark =
    any isAlpha remark
        && (remark
                |> filter isAlpha
                |> all isUpper
           )


isQuestion : String -> Bool
isQuestion remark =
    endsWith "?" (trimRight remark)


isSilence : String -> Bool
isSilence remark =
    isEmpty (trim remark)
