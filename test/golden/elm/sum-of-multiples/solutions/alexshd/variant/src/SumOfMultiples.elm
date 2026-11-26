module SumOfMultiples exposing (sumOfMultiples)

import List
import Set


sumOfMultiples : List Int -> Int -> Int
sumOfMultiples divisors limit =
    List.concatMap (filterDividable limit) divisors
        |> sumUniques


filterDividable : Int -> (Int -> List Int)
filterDividable limit divisor =
    List.range 1 (limit + 1)
        |> List.filter (isDividable divisor)


isDividable : Int -> Int -> Bool
isDividable divisor num =
    modBy divisor num == 0


sumUniques : List number -> number
sumUniques list =
    Set.fromList list |> Set.toList |> List.sum
