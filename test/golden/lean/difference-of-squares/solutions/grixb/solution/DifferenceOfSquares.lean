namespace DifferenceOfSquares

def squareOfSum (n : Nat) : Nat :=
  (n^2 * (n+1)^2) / 4

def sumOfSquares (n : Nat) : Nat :=
  (n * (n+1) * (2*n + 1)) / 6

def differenceOfSquares (n : Nat) : Nat :=
  squareOfSum n - sumOfSquares n

end DifferenceOfSquares
