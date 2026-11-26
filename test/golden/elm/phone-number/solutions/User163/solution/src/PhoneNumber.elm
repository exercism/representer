module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        nr = String.filter Char.isDigit phoneNumber
    in
        if(String.length nr == 11) then
            if ((String.left 1 nr =="1")&&(checkN (String.dropLeft 1 nr)))then
                Just (String.dropLeft 1 nr)
            else
                Nothing
        else if ((String.length nr == 10)&&(checkN nr)) then
                Just nr
        else 
            Nothing


checkN : String -> Bool
checkN s =
    if (String.left 1 s == "0" || String.left 1 s == "1") || (String.left 1 (String.dropLeft 3 s) == "0" || String.left 1 (String.dropLeft 3 s) == "1") then
        False
    else 
        True
