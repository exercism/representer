module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        digits =
            phoneNumber |> String.toList |> List.filter Char.isDigit

        validate : Char -> Char -> a -> Maybe a
        validate areaFst exchangeFst num =
            if areaFst > '1' && exchangeFst > '1' then
                Just num

            else
                Nothing

        validDigits : Maybe (List Char)
        validDigits =
            case digits of
                [ '1', a1, _, _, e1, _, _, _, _, _, _ ] ->
                    digits |> List.drop 1 |> validate a1 e1

                [ a1, _, _, e1, _, _, _, _, _, _ ] ->
                    digits |> validate a1 e1

                _ ->
                    Nothing
    in
    validDigits |> Maybe.map String.fromList
