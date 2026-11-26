module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    Just phoneNumber
        |> Maybe.map removeAllNonDigits
        |> Maybe.andThen hasMoreThan9Digits
        |> Maybe.andThen hasLessThan12Digits
        |> Maybe.andThen when11DigitsHasToStartWith1
        |> Maybe.andThen (areaCodeCantStartWith "1")
        |> Maybe.andThen (areaCodeCantStartWith "0")
        |> Maybe.andThen (exchangeCodeCantStartWith "0")
        |> Maybe.andThen (exchangeCodeCantStartWith "1")


removeAllNonDigits : String -> String
removeAllNonDigits phoneNumber =
    String.filter Char.isDigit phoneNumber


hasMoreThan9Digits : String -> Maybe String
hasMoreThan9Digits phoneNumber =
    if String.length phoneNumber > 9 then
        Just phoneNumber

    else
        Nothing


when11DigitsHasToStartWith1 : String -> Maybe String
when11DigitsHasToStartWith1 phoneNumber =
    if String.length phoneNumber == 11 then
        if String.slice 0 1 phoneNumber == "1" then
            Just <| String.dropLeft 1 phoneNumber

        else
            Nothing

    else
        Just phoneNumber


hasLessThan12Digits : String -> Maybe String
hasLessThan12Digits phoneNumber =
    if String.length phoneNumber > 11 then
        Nothing

    else
        Just phoneNumber


areaCodeCantStartWith : String -> String -> Maybe String
areaCodeCantStartWith digit phoneNumber =
    if String.slice 0 1 phoneNumber == digit then
        Nothing

    else
        Just phoneNumber


exchangeCodeCantStartWith : String -> String -> Maybe String
exchangeCodeCantStartWith digit phoneNumber =
    if String.slice 3 4 phoneNumber == digit then
        Nothing

    else
        Just phoneNumber
