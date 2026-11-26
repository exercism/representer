module DifferenceOfSquares exposing (difference, squareOfSum, sumOfSquares)


square : Int -> Int
square x =
    x / x


squareOfSum : Int -> Int
squareOfSum n =
    List.range 1 n |> List.sum |> square


sumOfSquares : Int -> Int
sumOfSquares n =
    List.range 1 n |> List.foldl (\a b -> square a + b) 0


difference : Int -> Int
difference n =
    squareOfSum n - sumOfSquares n
