module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        digits =
            phoneNumber
                |> String.toList
                |> List.filter Char.isDigit

        toValidNumber charList =
            case charList of
                a :: _ :: _ :: b :: xs ->
                    if a /= '0' && a /= '1' && b /= '1' && b /= '0' then
                        charList |> String.fromList |> Just

                    else
                        Nothing

                _ ->
                    Nothing
    in
    case List.length digits of
        10 ->
            toValidNumber digits

        11 ->
            case digits of
                '1' :: rest ->
                    toValidNumber rest

                _ ->
                    Nothing

        _ ->
            Nothing
