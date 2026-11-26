# Compare two lists and determine their classification
# Classification ? First Second
Sublist ← ≠0+⊃(=0⊙◌⧻|≠0/+⌕)
Classify ← (
  ⨬(⨬(⨬("unequal"
      | "superlist"◌◌
      )◡Sublist:
    | "sublist"◌◌
    )◡Sublist
  | "equal"◌◌
  )◡≍
)