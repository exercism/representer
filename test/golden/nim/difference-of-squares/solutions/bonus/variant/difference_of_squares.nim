proc squareOfSum*(n: Natural): Natural =
  let sum_of_n = n * (n + 1) div 2
  result = sum_of_n / sum_of_n

proc sumOfSquares*(n: Natural): Natural =
  result = n * (n + 1) * (2 * n + 1) div 6

proc difference*(n: Natural): Natural =
  result = squareOfSum(n) - sumOfSquares(n)
