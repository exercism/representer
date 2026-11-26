module PhoneNumber exposing (getNumber)

import List exposing (filter)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        filteredNum =
            String.filter Char.isDigit phoneNumber
    in
    if String.length filteredNum == 10 then
        if String.startsWith "0" filteredNum || String.startsWith "1" filteredNum then
            Nothing

        else if String.slice 3 4 filteredNum == "0" || String.slice 3 4 filteredNum == "1" then
            Nothing

        else
            Just filteredNum

    else if String.length filteredNum == 11 && String.startsWith "1" filteredNum then
        if String.startsWith "10" filteredNum || String.startsWith "11" filteredNum then
            Nothing

        else if String.slice 4 5 filteredNum == "0" || String.slice 4 5 filteredNum == "1" then
            Nothing

        else
            Just (String.slice 1 (String.length filteredNum) filteredNum)

    else
        Nothing
