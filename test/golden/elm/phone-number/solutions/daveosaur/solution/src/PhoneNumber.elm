module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        num = String.filter Char.isDigit phoneNumber
    in
    case (String.left 1 num) of
        "1"          -> validateNumber (String.right 10 num)
        _            -> validateNumber num

validateNumber : String -> Maybe String
validateNumber phoneNumber =
    let
        invalid = (String.indices "0" phoneNumber) ++ (String.indices "1" phoneNumber)
            |> List.any (\n -> n == 0 || n == 3)
    in
    if not invalid && String.length phoneNumber == 10 then
        Just phoneNumber
    else
        Nothing