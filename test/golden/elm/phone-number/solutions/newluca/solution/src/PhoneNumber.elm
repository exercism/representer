module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        cleaned =
            String.filter Char.isDigit phoneNumber

        length =
            String.length cleaned
    in
    if length < 10 || length > 11 then
        Nothing

    else if length == 11 then
        if String.startsWith "1" cleaned && String.left 2 cleaned /= "11" && String.left 2 cleaned /= "10" && String.slice 4 5 cleaned /= "0" && String.slice 4 5 cleaned /= "1" then
            Just (String.dropLeft 1 cleaned)

        else
            Nothing

    else if String.left 1 cleaned == "1" || String.left 1 cleaned == "0" || String.slice 3 4 cleaned == "0" || String.slice 3 4 cleaned == "1" then
        Nothing

    else
        Just cleaned
