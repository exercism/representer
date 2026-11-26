module Series exposing (slices)


slices : Int -> String -> Result String (List (List Int))
slices size input =
    let 
        slice : Int -> String
        slice n =
            String.slice n (n+size) input

        toInt : Char -> Int
        toInt c =
            String.fromChar c
                |> String.toInt
                |> Maybe.withDefault 0

        stringToInt : String -> List Int
        stringToInt str =
            String.toList str
                |> List.filter Char.isDigit
                |> List.map toInt
    in
    if size < 0 then
        Result.Err "slice length cannot be negative"
    else if size == 0 then
        Result.Err "slice length cannot be zero"
    else if String.isEmpty input then
        Result.Err "series cannot be empty"
    else if size > String.length input then
        Result.Err "slice length cannot be greater than series length"
    else
        List.range 0 ((String.length input)-size)
            |> List.map slice
            |> List.map stringToInt
            |> Result.Ok
