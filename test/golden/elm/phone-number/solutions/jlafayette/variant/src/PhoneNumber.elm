module PhoneNumber exposing (getNumber)

import Set exposing (Set)


areaCodeInvalid : String -> Bool
areaCodeInvalid code =
    let
        first =
            String.slice 1 1 code

        zeroOrOne =
            [ "0", "1" ] |> Set.fromList
    in
    Set.member first zeroOrOne


exchangeCodeInvalid =
    areaCodeInvalid


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        digits =
            phoneNumber |> String.filter Char.isDigit

        len =
            String.length digits

        validLen =
            [ 10, 11 ] |> Set.fromList

        -- These are done relative to the end of the digits, so
        -- it works with both 10 and 11 digit numbers.
        subscriberNumber =
            String.slice -4 11 digits

        exchangeCode =
            String.slice -7 -4 digits

        areaCode =
            String.slice -10 -7 digits

        -- For 10 digit numbers, country code will be empty
        countryCode =
            String.slice -11 -10 digits

        validCountryCodes =
            [ "", "1" ] |> Set.fromList
    in
    if not (Set.member len validLen) then
        Nothing

    else if not (Set.member countryCode validCountryCodes) then
        Nothing

    else if areaCodeInvalid areaCode then
        Nothing

    else if exchangeCodeInvalid exchangeCode then
        Nothing

    else
        Just (String.concat [ areaCode, exchangeCode, subscriberNumber ])
