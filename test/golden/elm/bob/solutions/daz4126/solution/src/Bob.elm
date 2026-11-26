module Bob exposing (hey)


hey : String -> String
hey input =
    let
        remark =
            String.trim input
    in
    if silent remark then
        "Fine. Be that way!"

    else if forcefulQuestion remark then
        "Calm down, I know what I'm doing!"

    else if question remark then
        "Sure."

    else if forceful remark then
        "Whoa, chill out!"

    else
        "Whatever."

silent : String -> Bool
silent =
    String.isEmpty

question : String -> Bool
question =
    String.endsWith "?"


forceful : String -> Bool
forceful remark =
    remark == String.toUpper remark && remark /= String.toLower remark


forcefulQuestion : String -> Bool
forcefulQuestion remark =
    question remark && forceful remark
