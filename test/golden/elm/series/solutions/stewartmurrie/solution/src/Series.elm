module Series exposing (slices)

import List exposing (filterMap)


slices : Int -> String -> Result String (List (List Int))
slices size input =
    let
        len =
            String.length input
    in
    if len == 0 then
        Err "series cannot be empty"

    else if size == 0 then
        Err "slice length cannot be zero"

    else if size > len then
        Err "slice length cannot be greater than series length"

    else if size < 0 then
        Err "slice length cannot be negative"

    else
        input
            |> String.split ""
            |> List.filterMap String.toInt
            |> subslices size
            |> Ok


subslices : Int -> List Int -> List (List Int)
subslices size list =
    let
        first =
            List.take size list
    in
    if List.length first < size then
        []

    else
        first :: subslices size (List.drop 1 list)
