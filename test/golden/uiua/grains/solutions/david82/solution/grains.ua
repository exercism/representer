# The number of grains on a square
# Grains ? Square
Square ← (
  # Validate input is between 1 and 64
  ⍤"square must be between 1 and 64"×⊃≥₁≤₆₄.
  # Calculate 2^(n-1)
  ⁿ:2-1
)

# The total number of grains on the board
# Total ?
Total ← ⁿ64 2
