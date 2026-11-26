# Calculate the square of the sums of the first N natural numbers
SquareOfSum         ← ×./++1⇡
SumOfSquares        ← /+×.+2⇡
DifferenceOfSquares ← -⊃SumOfSquares SquareOfSum
