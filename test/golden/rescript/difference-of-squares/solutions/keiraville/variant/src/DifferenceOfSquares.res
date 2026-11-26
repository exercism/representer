let square = n => n * n

let squareOfSum = n => square(n * (n + 1) / 2)

let sumOfSquares = n => n * (n + 1) * (n + n - 1) / 6

let differenceOfSquares = n => squareOfSum(n) - sumOfSquares(n)
