module PhoneNumber exposing (getNumber)

import String
import Char

getNumber : String -> Maybe String
getNumber phoneNumber =
    String.filter Char.isDigit phoneNumber
    |> String.toList
    |> stripAreaCode
    |> validateNumber
    |> Maybe.map String.fromList

stripAreaCode : List Char -> List Char
stripAreaCode numbers =
    if List.length numbers == 11 && List.head numbers == Just '1' then
        List.drop 1 numbers
    else
        numbers

validateNumber : List Char -> Maybe (List Char)
validateNumber numbers =
    let
        firstDigitArea = List.head (List.take 1 numbers)
        firstDigitExchange = List.head (List.take 1 (List.drop 3 numbers))
    in
        if List.length numbers /= 10
            || firstDigitArea == Just '0'
            || firstDigitArea == Just '1'
            || firstDigitExchange == Just '0'
            || firstDigitExchange == Just '1'
        then
            Nothing
        else
            Just numbers