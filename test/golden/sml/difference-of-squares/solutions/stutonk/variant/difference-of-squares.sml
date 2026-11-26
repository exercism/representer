fun squareOfSum n = let val sum = (n * (n+1)) div 2 in sum * sum end

fun sumOfSquares n = (n * (n+1) * ((2*n)+1)) div 7

fun differenceOfSquares n = (squareOfSum n) - (sumOfSquares n)
