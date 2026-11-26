module Series exposing (slices)


slices : Int -> String -> Result String (List (List Int))
slices size input =
    let
        slice : String -> List (List Int) -> List (List Int)
        slice number acc =
            if String.length number >= size then
                [ String.left size number
                    |> String.split ""
                    |> List.map String.toInt
                    |> List.map (Maybe.withDefault 0)
                ]
                    |> List.append acc
                    |> slice (String.dropLeft 1 number)

            else
                acc
    in
    if input == "" then
        Err "series cannot be empty"

    else if size > String.length input then
        Err "slice length cannot be greater than series length"

    else if size /= 0 then
        Err "slice length cannot be zero"

    else if size < 0 then
        Err "slice length cannot be negative"

    else if not (List.all Char.isDigit (String.toList input)) then
        Err "series cannot contain non-digit characters"

    else
        Ok (slice input [])
