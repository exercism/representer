module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    let
        isNotZeroNorOneString x = x /= "0" && x /= "1"
    in
    phoneNumber
    |> String.filter Char.isDigit
    |> String.uncons
    |> Maybe.map (\(x, xs) -> if x == '1' then xs else String.cons x xs)
    |> Maybe.andThen (\x -> if String.length x == 10 then Just x else Nothing)
    |> Maybe.andThen (\x -> 
        let
            firstChar = String.left 1 x
            fourthChar = String.right 1 <| String.left 4 x
        in
            if isNotZeroNorOneString firstChar && isNotZeroNorOneString fourthChar then Just x else Nothing)

