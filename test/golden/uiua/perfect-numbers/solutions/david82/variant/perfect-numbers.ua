# Validate input is positive
Validate ← ⍤"number must be positive" >0

# Get factors of a number (excluding itself)
Factors ← ▽:⟜(=0◿)⊸(↘1⇡)

# Calculate aliquot sum (sum of proper divisors)
AliquotSum ← /+ Factors

# Classify a positive integer based on its aliquot sum
# Classification ? Number
ClassifyNumber ← ⨬("abundant"|"perfect"|"deficient") -1±-⊸AliquotSum Validate .
