# The number of grains on a square
# Grains ? Square
Square ← ⁿ:2-1 ⍤("square must be between 1 and 64") ↧⊃(≤64|≥1) .


# The total number of grains on the board
# Total ?
Total ← /+≡Square-1⇡64
