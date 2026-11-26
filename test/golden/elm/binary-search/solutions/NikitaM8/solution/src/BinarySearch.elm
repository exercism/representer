module BinarySearch exposing (find)

import Array exposing (Array)


find : Int -> Array Int -> Maybe Int
find target xs =
    find_ target xs 0 (Array.length xs)


find_ : Int -> Array Int -> Int -> Int -> Maybe Int
find_ target xs left right =
    let
        pivot =
            left + ((right - left) // 2)

        pivotValue =
            Array.get pivot xs |> Maybe.withDefault 0
    in
    if right - left == 0 then
        Nothing

    else if target == pivotValue then
        Just pivot

    else if target < pivotValue then
        find_ target xs left pivot

    else
        find_ target xs (pivot + 1) right
