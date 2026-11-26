module Series exposing (slices)

makeSubs: Int -> String -> List String
makeSubs n s =
    if String.length s < n then
        []
    else
        String.left n s :: (makeSubs n (String.dropLeft 1 s))


stringToInts: String -> List Int
stringToInts input =
    input
        |> String.toList
        |> List.map (\d -> Maybe.withDefault -1 (String.toInt (String.fromChar d)))


slices : Int -> String -> Result String (List (List Int))
slices size input =
    if size ==0 then Err "slice length cannot be zero"
    else if size < 0 then Err "slice length cannot be negative"
    else if String.length input == 0 then Err "series cannot be empty"
    else if String.length input < size then Err "slice length cannot be greater than series length"
    else
        Ok (List.map (\s -> stringToInts s) (makeSubs size input))
