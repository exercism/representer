module Bob exposing (hey)


hey : String -> String
hey remark =
    let
        zero_sum_gain =
            String.toUpper remark == String.toLower remark

        yell =
            not zero_sum_gain && String.toUpper remark == remark

        question =
            String.endsWith "?" (String.trim remark)

        yell_question =
            yell && question

        empty =
            String.isEmpty (String.trim remark)
    in
    if yell_question then
        "Calm down, I know what I'm doing!"

    else if yell then
        "Whoa, chill out!"

    else if question then
        "Sure."

    else if empty then
        "Fine. Be that way!"

    else
        "Whatever."
