module PhoneNumber exposing (getNumber)

import String exposing (..)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        cleanedNumber =
            filter Char.isDigit phoneNumber
    in
    if length cleanedNumber == 10 then
        getNumberAdvanced cleanedNumber

    else if length cleanedNumber == 11 && startsWith "1" cleanedNumber then
        getNumberAdvanced (dropLeft 1 cleanedNumber)

    else
        Nothing


getNumberAdvanced : String -> Maybe String
getNumberAdvanced number =
    let
        areaCode =
            slice 0 3 number

        exchangeCode =
            slice 3 6 number
    in
    if
        startsWith "0" areaCode
            || startsWith "1" areaCode
            || startsWith "0" exchangeCode
            || startsWith "1" exchangeCode
    then
        Nothing

    else
        Just number
