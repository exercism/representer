module PhoneNumber exposing (getNumber)

import Regex


getNumber : String -> Maybe String
getNumber phoneNumber =
    onlyDigits phoneNumber
        |> removeContryCode
        |> validate


onlyDigits : String -> String
onlyDigits phoneNumber =
    String.filter Char.isDigit phoneNumber


removeContryCode : String -> String
removeContryCode phoneNumber =
    if String.length phoneNumber == 11 && String.left 1 phoneNumber == "1" then
        String.dropLeft 1 phoneNumber

    else
        phoneNumber


validRe : Regex.Regex
validRe =
    Maybe.withDefault Regex.never <|
        Regex.fromString "^([2-9][0-9]{2}){2}[0-9]{4}$"


validate : String -> Maybe String
validate phoneNumber =
    if Regex.contains validRe phoneNumber then
        Just phoneNumber

    else
        Nothing
