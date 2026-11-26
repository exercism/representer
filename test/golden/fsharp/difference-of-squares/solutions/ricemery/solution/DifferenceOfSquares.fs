module DifferenceOfSquares

let squareOfSum (n: int): int = 
    let m = n * (n + 1) / 2
    m * m

let sumOfSquares (n: int): int = 
    n * (n + 1) * (2 * n + 1) / 6

let differenceOfSquares (n: int): int = 
    squareOfSum n - sumOfSquares n