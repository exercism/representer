module PhoneNumber exposing (getNumber, cleanNumber, removeCountryCode, isValidN)

cleanNumber : String -> Maybe String
cleanNumber phoneNumber =
    let
        cleanData = String.filter Char.isDigit phoneNumber 
    in
    case String.isEmpty cleanData of
        True ->
            Nothing
        False ->
            Just cleanData
        
removeCountryCode : Maybe String -> Maybe String
removeCountryCode phoneNumber =
    let
        number = Maybe.withDefault "" phoneNumber
    in
    case String.slice 0 1 number of
        "" ->
            Nothing
        "1" ->
            Just (String.slice 1 (String.length number) number)
        _ ->
            Just number

isNumber2_9 : String -> Int -> Int -> Bool
isNumber2_9 phoneNumber start end =
    let 
        number = String.slice start end phoneNumber
    in
        List.member number ["2", "3", "4", "5", "6", "7", "8", "9"]
        
    
isValidN : Maybe String -> Bool
isValidN phoneNumber =
    case phoneNumber of
        Nothing ->
            False
        Just number ->
            isNumber2_9 number 0 1 == True && isNumber2_9 number 3 4 == True
    

getNumber : String -> Maybe String
getNumber phoneNumber =
    let number = cleanNumber phoneNumber
            |> removeCountryCode
    in
    if String.length (Maybe.withDefault "" number) == 10 && isValidN number then
        number
    else
        Nothing
