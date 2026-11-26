# Calculate the square of the sums of the first N natural numbers
SquareOfSum         ← ×./++1⇡
SumOfSquares        ← /+×.+1⇡
DifferenceOfSquares ← -⊃SumOfSquares SquareOfSum
