module PhoneNumber exposing (getNumber)

import Char exposing (isDigit)
import String

getNumber : String -> Maybe String
getNumber phoneNumber = 
    let
        clean_string = String.filter isDigit phoneNumber
        length = String.length clean_string
    in
    case length of 
        10 -> validateNumber clean_string
        11 -> if String.startsWith "1" clean_string then 
                validateNumber (String.dropLeft 1 clean_string) 
            else 
                Nothing
        _ -> Nothing
        
validateNumber : String -> Maybe String
validateNumber clean_string =
    case String.toList clean_string of
        '0' :: _ -> Nothing
        '1' :: _ -> Nothing
        _ :: _ :: _ :: '0' :: _ -> Nothing
        _ :: _ :: _ :: '1' :: _ -> Nothing
        _ -> Just clean_string
