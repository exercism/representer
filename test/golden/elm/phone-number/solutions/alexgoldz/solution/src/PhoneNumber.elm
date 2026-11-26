module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        cleaned : String
        cleaned =
            String.filter Char.isDigit phoneNumber

        toValidLength : String -> Result String String
        toValidLength num =
            case compare (String.length num) 10 of
                LT ->
                    Err "Too short"

                EQ ->
                    Ok num

                GT ->
                    if String.length num > 11 then
                        Err "Too long"

                    else if not (String.startsWith "1" num) then
                        Err "Invalid country code"

                    else
                        Ok <| String.dropLeft 1 num

        toValidAreaCode : String -> Result String String
        toValidAreaCode num =
            case String.left 1 num of
                "0" ->
                    Err "Invalid Area code start with  0"

                "1" ->
                    Err "Invalid Area code start with 1"

                _ ->
                    Ok num

        toValidExchangeCode : String -> Result String String
        toValidExchangeCode num =
            case String.slice 3 4 num of
                "0" ->
                    Err "Invalid Area code start with  0"

                "1" ->
                    Err "Invalid Area code start with 1"

                _ ->
                    Ok num
    in
    toValidLength cleaned
        |> Result.andThen toValidAreaCode
        |> Result.andThen toValidExchangeCode
        |> Result.toMaybe
