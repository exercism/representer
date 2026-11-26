fun square n = n * n

fun squareOfSum n =
  square ((n * (n + 1)) div 2)

fun sumOfSquares n =
  (n * (n + 1) * (2 * n + 1)) div 6

fun differenceOfSquares n =
  squareOfSum n - sumOfSquares n
