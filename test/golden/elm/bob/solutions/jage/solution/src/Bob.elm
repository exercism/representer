module Bob exposing (hey)

hey : String -> String
hey raw_remark =
    let
        remark =
            String.trim raw_remark
    in
    if String.endsWith "?" remark then
        if isAllCaps remark then
            "Calm down, I know what I'm doing!"
        else
            "Sure."
    else if isAllCaps remark then
        "Whoa, chill out!"
    else if String.isEmpty remark then
        "Fine. Be that way!"
    else
        "Whatever."

isAllCaps : String -> Bool
isAllCaps input =
    String.toLower input /= input && String.toUpper input == input
