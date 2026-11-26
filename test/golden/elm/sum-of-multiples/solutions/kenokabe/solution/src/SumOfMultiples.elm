module SumOfMultiples exposing (sumOfMultiples)


{-| Calculate the sum of all multiples of given factors below a limit.

    sumOfMultiples [3, 5] 15 == 45

-}
sumOfMultiples : List Int -> Int -> Int
sumOfMultiples factors limit =
    List.range 1 (limit - 1)
        |> List.filter (\n -> List.any (\factor -> modBy factor n == 0) factors)
        |> List.sum
