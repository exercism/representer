module Series exposing (slices)


slices : Int -> String -> Result String (List (List Int))
slices size input =
    case ( size <= 0, String.isEmpty input, size > String.length input ) of
        ( True, _, _ ) ->
            Err <| "slice length cannot be " ++ stringFromValueRange size

        ( _, True, _ ) ->
            Err "series cannot be empty"

        ( _, _, True ) ->
            Err "slice length cannot be greater than series length"

        _ ->
            List.range 0 (String.length input - size)
                |> List.map (sliceOfLengthFrom size input)
                |> List.map String.toList
                |> List.map (List.map (String.fromChar >> String.toInt))
                |> List.map resultFromMaybes
                |> List.foldr (Result.map2 (::)) (Ok [])


sliceOfLengthFrom : Int -> String -> Int -> String
sliceOfLengthFrom size input start =
    String.slice start (start + size) input


resultFromMaybes : List (Maybe a) -> Result String (List a)
resultFromMaybes maybeInts =
    maybeInts
        |> List.foldr (Maybe.map2 (::)) (Just [])
        |> Result.fromMaybe "Some of these were Nothing!"


stringFromValueRange : Int -> String
stringFromValueRange value =
    case (value < 0, value > 0) of
        (True, _) -> "negative"

        (_, True) -> "positive"

        _ -> "zero"
