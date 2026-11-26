module SumOfMultiples exposing (sumOfMultiples)


sumOfMultiples : List Int -> Int -> Int
sumOfMultiples divisors limit =
    List.range 1 (limit - 1)
    |> List.filter (\n -> List.any (\m -> modBy m n == 0) divisors)
    |> List.sum
