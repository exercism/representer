module Series exposing (slices)


slices : Int -> String -> Result String (List (List Int))
slices size input =
    if String.length input == 0 then
        Err "series cannot be empty"

    else if size < 0 then
        Err "slice length cannot be negative"

    else if size == 0 then
        Err "slice length cannot be zero"

    else if size > String.length input then
        Err "slice length cannot be greater than series length"

    else
        let
            digits =
                List.map toDigit (String.toList input)
        in
        -- Based on https://exercism.org/tracks/elm/exercises/series/solutions/Elm
        List.range 0 (List.length digits - size)
            |> List.map (\i -> digits |> List.drop i |> List.take size)
            |> Ok


toDigit : Char -> Int
toDigit digitChar =
    Char.toCode digitChar - Char.toCode '0'
