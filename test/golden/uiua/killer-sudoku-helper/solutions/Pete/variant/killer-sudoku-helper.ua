# Combinations of given size from array
# ArrayOfCombs ? Size ArrayOfNumbers
Combs ↚ |2 (
  ⋯⇡ⁿ:2⧻⟜¤ :       # make masks for the superset
  ⊃(⊸≡(/+) ⊙⋅∘|⋅∘) # count bits set in each
  ▽ ⊃(=⊙⋅∘|⋅⊙⋅∘)   # mask of those with Size bits set
  ≡▽               # and keep wanted combinations
  ⍆                # in sorted order
)

# Find the valid combinations for a sudoku cage
# Combinations ? Exclude Size Sum
Combinations ← |4 (
  ⊙(↧₉+₁◡-)    # find largest integer min(9,(Sum+1-Size))
  ⊙(+₁⇡)       # make array of integers
  ▽¬⊸∊         # remove excluded integers
  Combs:       # generate combinations of Size
  ▽ ⤚≡(=/+) ⊙¤ # filter those that add to Sum
)
