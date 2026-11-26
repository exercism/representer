module DifferenceOfSquares exposing (difference, squareOfSum, sumOfSquares)


squareOfSum : Int -> Int
squareOfSum n =
    (List.sum (List.range 1 n)) ^ 2
     
sumOfSquares : Int -> Int
sumOfSquares n =
    List.foldl (\x a -> (x^2) + a) 0 (List.range 1 n)

difference : Int -> Int
difference n =
    squareOfSum n - sumOfSquares n
