func squareOfSum*(n: int): int =
  for i in 1..n: result += i
  result *= result 

func sumOfSquares*(n: int): int =
  for i in 1..n: result += i*i

func difference*(n: int): int =
  squareOfSum(n) - sumOfSquares(n)
