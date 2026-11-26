module DifferenceOfSquares

let sqr x =
    x * x

let squareOfSum (number: int): int = 
    [1..number]
    |> List.sum
    |> sqr
let sumOfSquares (number: int): int =
    [1..number]
    |> List.sumBy sqr
    
let differenceOfSquares (number: int): int = 
    squareOfSum number - sumOfSquares number