module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        cleanedPhoneNumber =
            phoneNumber
            |> String.filter Char.isDigit
        formattedPhoneNumber =
            if String.startsWith "1" cleanedPhoneNumber && String.length cleanedPhoneNumber == 11
            then String.dropLeft 1 cleanedPhoneNumber
            else cleanedPhoneNumber
        validateNumberAtIndex index =
            List.member (String.slice index (index+1) formattedPhoneNumber) (List.range 2 9 |> List.map String.fromInt)
        isValid =
            (String.length formattedPhoneNumber) == 10
            && validateNumberAtIndex 0
            && validateNumberAtIndex 3 
    in
        if isValid
        then
            Just formattedPhoneNumber
        else
            Nothing
