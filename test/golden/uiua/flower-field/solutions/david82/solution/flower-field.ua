# Keep original flowers and trim padding
KeepFlowers ← (
  ∧⍜⊡(@*◌)⊚=@*:↘¯1_¯1↘1_1
)

# Process a garden by counting neighbors
FlowerCount ← (
  ⬚@ ⧈(+@0⧻⊚=@*⍜⊡(@ ◌)1_1)3_3.      # Pad and count neighbors
  KeepFlowers                       # Keep original flowers
  ≡(⍥(@ ◌)=@0.)                     # Replace 0 with space
)

# Annotate a garden
# Annotated ? Garden
Annotate ← |1 ⨬(FlowerCount|∘)∊:0△.
