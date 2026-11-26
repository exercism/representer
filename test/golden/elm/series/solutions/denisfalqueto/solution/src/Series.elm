module Series exposing (slices)


slices : Int -> String -> Result String (List (List Int))
slices size input =
    if size < 0 then
        Err "slice length cannot be negative"

    else if size == 0 then
        Err "slice length cannot be zero"

    else if String.isEmpty input then
        Err "series cannot be empty"

    else if size > String.length input then
        Err "slice length cannot be greater than series length"

    else
        Ok
            ((input
                |> String.slice 0 size
                |> String.foldl
                    (\c l ->
                        List.append l
                            [ c
                                |> String.fromChar
                                |> String.toInt
                                |> Maybe.withDefault 0
                            ]
                    )
                    []
             )
                :: (slices size (String.dropLeft 1 input)
                        |> Result.withDefault []
                   )
            )
