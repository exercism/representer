module Bob exposing (hey)

import Char exposing (isDigit)
import String exposing (endsWith, filter, isEmpty, length, toUpper, trim)


hey : String -> String
hey remark =
    let
        equalUpper : String -> Bool
        equalUpper s =
            toUpper s == s

        filteredRemark : String -> String
        filteredRemark s =
            let
                filteredCh : Char -> Bool
                filteredCh ch =
                    not
                        (isDigit ch
                            || ch
                            == ','
                            || ch
                            == ':'
                            || ch
                            == ')'
                            || ch
                            == ' '
                            || ch
                            == '\t'
                            || ch
                            == '\n'
                            || ch
                            == '\u{000D}'
                        )
            in
            s
                |> filter filteredCh

        filtered =
            remark
                |> filteredRemark

        eqUpper : Bool
        eqUpper =
            remark |> equalUpper
    in
    if
        remark
            |> trim
            |> isEmpty
    then
        "Fine. Be that way!"

    else if endsWith "?" filtered then
        if eqUpper && length filtered > 1 then
            "Calm down, I know what I'm doing!"

        else
            "Sure."

    else if eqUpper && length filtered > 0 then
        "Whoa, chill out!"

    else
        "Whatever."
