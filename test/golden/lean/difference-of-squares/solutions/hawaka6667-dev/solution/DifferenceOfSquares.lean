namespace DifferenceOfSquares

def squareOfSum (number : Nat) : Nat :=
  let s := number * (number + 1) / 2
  s * s

def sumOfSquares (number : Nat) : Nat :=
  number * (number + 1) * (2 * number + 1) / 6

def differenceOfSquares (number : Nat) : Nat :=
  squareOfSum number - sumOfSquares number

end DifferenceOfSquares