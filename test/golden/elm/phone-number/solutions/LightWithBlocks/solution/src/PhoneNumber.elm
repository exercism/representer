module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber = 
    let
        removePunctuation = String.filter Char.isDigit
        removeFirstOne pN = if String.startsWith "1" pN then String.dropLeft 1 pN else pN
        firstNumberAboveOne pN = not (String.startsWith "0" pN || String.startsWith "1" pN)
        thirdNumberAboveOne pN = 
            let
                pN3 = String.dropLeft 3 pN
            in
            not (String.startsWith "0" pN3 || String.startsWith "1" pN3)
        validPhoneNumber pN = if (String.length pN == 10 && firstNumberAboveOne pN && thirdNumberAboveOne pN) then Just pN else Nothing
    in
    removePunctuation phoneNumber |> removeFirstOne |> validPhoneNumber
