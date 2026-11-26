module PhoneNumber exposing (getNumber)

removeUsa : String -> Maybe String
removeUsa phoneNumber = 
  let
    phoneDigs = String.toList phoneNumber
  in
    case List.length phoneDigs of
        11 -> 
            case phoneDigs of
                '1' :: tail -> Just (String.fromList tail)
                _ -> Nothing

        _ -> Just phoneNumber


cleanAuxUsa : String -> Maybe String
cleanAuxUsa phoneNumber = 
  let
    justDigs = phoneNumber
                |> String.filter (\c -> String.indices (String.fromChar c) "()- .+"|> List.isEmpty) 
                |> String.filter Char.isDigit
  in
    case String.length justDigs of
        11 -> removeUsa justDigs
        10 -> Just justDigs
        _ -> Nothing


codesOk : String -> Bool
codesOk number = 
  let
    checkCode : String -> Bool
    checkCode c = 
        case String.toInt c of
            Nothing -> False
            Just d -> 1 < d && d <= 9

    ac = String.slice 0 1 number
    ec = String.slice 3 4 number
  in
    checkCode ac && checkCode ec


getNumber : String -> Maybe String
getNumber phoneNumber =
    cleanAuxUsa phoneNumber
        |> Maybe.andThen (\n -> if codesOk n then Just n else Nothing)
