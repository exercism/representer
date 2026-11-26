module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        justDigits = String.filter Char.isDigit phoneNumber
    in
        if hasValidLength justDigits && hasValidCountryCode justDigits && hasValidAreaCode justDigits then
            justDigits
            |> String.right 10
            |> Just
        else
            Nothing

hasValidLength : String -> Bool
hasValidLength s =
    case String.length s of
        10 -> True
        11 -> True
        _ -> False

hasValidCountryCode : String -> Bool
hasValidCountryCode s =
    if String.length s == 11 then
        String.startsWith "1" s
    else
        True

hasValidAreaCode : String -> Bool
hasValidAreaCode s =
    let
        localAreaCode = 
            s
            |> String.right 7
            |> String.dropRight 6
            |> String.toInt
        
        planAreaCode =
            s
            |> String.right 10
            |> String.dropRight 9
            |> String.toInt
    in
        case (localAreaCode, planAreaCode) of
            (Just l, Just p) -> List.all (\n -> 2 <= n && n <= 9) [l, p]
            _ -> False