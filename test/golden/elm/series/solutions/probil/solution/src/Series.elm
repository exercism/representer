module Series exposing (slices)


generateSlices : String -> Int -> List String
generateSlices input size =
    (String.length input - size)
        |> List.range 0
        |> List.map (\startIndex -> String.slice startIndex (startIndex + size) input)


strToDigits : String -> List Int
strToDigits str =
    str
        |> String.split ""
        |> List.filterMap String.toInt


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
        generateSlices input size
            |> List.map strToDigits
            |> Ok
