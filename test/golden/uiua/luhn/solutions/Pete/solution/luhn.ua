# Determine whether or not a string of digits is valid per the Luhn formula
# Valid ? String
Validate ← |1 ⍣(
  ▽⊸≠@\s              # remove spaces
  ⍤0>₁⊸⧻              # check long enough
  ⍤0 ⊸(/××⊃(≥@0|≤@9)) # check numeric
  -@0                 # chars to numbers
  ↙¯:↯:1_0¤(⍜÷₂⌈).⧻.  # make mask of alternate elements
  ⍜(▽
  | ×₂ # double alternate elements
    ⍜(▽|-₉)⊸>₉
  )       # adjust doubled > 9
  =₀◿₁₀/+ # i mod₁₀ zero?
| 0       # fails if asserts fail
)
