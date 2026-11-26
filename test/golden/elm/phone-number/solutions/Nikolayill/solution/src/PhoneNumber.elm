module PhoneNumber exposing (getNumber)


checkLocalNumber : List Char -> (List Char, Bool)
checkLocalNumber phone =
    let isAreaCodeValid = phone |> List.head |> Maybe.map (\c -> c > '1') |> Maybe.withDefault False
        isExCodeValid = phone |> (List.drop 3) |> List.head |> Maybe.map (\c -> c > '1') |> Maybe.withDefault False
    in
        (phone, isAreaCodeValid && isExCodeValid)

ifFlag : Maybe (a, Bool) -> Maybe a
ifFlag maybeChecked =
    case maybeChecked of
        Just (v, True) -> Just v
        _ -> Nothing


getNumber : String -> Maybe String
getNumber phoneNumber =
    let cleanedInput = phoneNumber |> String.toList |> List.filter Char.isDigit
        listLength = List.length cleanedInput
        isFirstIsOne = cleanedInput |> List.head |> Maybe.map (\c -> c == '1') |> Maybe.withDefault False
    in
        (if listLength==10 then Maybe.Just cleanedInput
        else if listLength==11 && isFirstIsOne then Maybe.Just (cleanedInput |> (List.drop 1)) 
        else Maybe.Nothing)
        |> Maybe.map (\number -> (checkLocalNumber number))
        |> ifFlag
        |> Maybe.map String.fromList 
        
