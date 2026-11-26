module PhoneNumber exposing (getNumber)

getNumber : String -> Maybe String
getNumber phoneNumber =
    let 
        cleaned = removeChars [' ', '(', ')', '-', '.', '+'] phoneNumber
        length = String.length cleaned
    in
    if String.any (\char -> Basics.not (Char.isDigit char)) cleaned then
        Nothing
    else if length > 11 || length < 10 then
        Nothing
    else if length == 11 then
        if (String.left 1 cleaned) /= "1" then
            Nothing
        else
            getNumber (String.dropLeft 1 cleaned)
    else
        case String.toList cleaned of
            '0' :: _ -> Nothing
            '1' :: _ -> Nothing
            _ :: _ :: _ :: '0' :: _ -> Nothing
            _ :: _ :: _ :: '1' :: _ -> Nothing
            _ -> Just (cleaned)

removeChars : List (Char) -> String -> String
removeChars toRemove phone =
    String.filter (\char -> Basics.not (List.member char toRemove)) phone