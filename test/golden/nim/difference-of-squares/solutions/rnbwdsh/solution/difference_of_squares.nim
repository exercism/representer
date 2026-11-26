proc squareOfSum*(n: int): int =
  for i in 1 .. n:
    result += i
  result *= result

proc sumOfSquares*(n: int): int =
  for i in 1 .. n:
    result += i * i

proc difference*(n: int): int =
  squareOfSum(n) - sumOfSquares(n)
