module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        verifyAreaCode =
            verifyCodeAt 0

        verifyExchangeCode =
            verifyCodeAt 3
    in
    phoneNumber
        |> String.filter Char.isDigit
        |> verifyCountryCode
        |> Maybe.andThen verifyAreaCode
        |> Maybe.andThen verifyExchangeCode


verifyCountryCode : String -> Maybe String
verifyCountryCode phoneNumber =
    case String.length phoneNumber of
        10 ->
            Just phoneNumber

        11 ->
            case String.uncons phoneNumber of
                Just ( '1', n ) ->
                    Just n

                _ ->
                    Nothing

        _ ->
            Nothing


verifyCodeAt : Int -> String -> Maybe String
verifyCodeAt index phoneNumber =
    if List.any (\c -> String.slice index (index + 1) phoneNumber == c) [ "0", "1" ] then
        Nothing

    else
        Just phoneNumber
