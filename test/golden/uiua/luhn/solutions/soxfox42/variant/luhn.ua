# Determine whether or not a string of digits is valid per the Luhn formula
# Valid ? String
Validate ← |2 ⍣(
  ▽⊸≠@      # filter spaces
  ≡⋕        # parse digits
  ⍤⟜(>1⧻).  # check length
  ⇌+1◿2°⊏   # generate doubling mask
  /+-×9⊸>9× # compute Luhn
  =0◿10     # check if valid
)0
