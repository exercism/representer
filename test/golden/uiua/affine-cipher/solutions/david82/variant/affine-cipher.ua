# Greatest common divisor
GCD ↚ ◌⍢(⤚◿|±)⌵

# Are 2 integer co-prime?
CoPrime ↚ =₁ GCD

# Precomputed character sets
LETTERS ↚ +@a⇡26

# encode a character
E ↚ |4 ⍜(-@a|◿26+×)

# Modular Multiplicative Inverse of A for M=26
MMI ↚ ⊙◌⍢(+₁|⨬(0⊙∘|≠₁◿₂₆◡×)⊸<₂₆) 1

# decode a character
D ↚ |3 ⍜(-@a|◿26 ×⊃(⋅MMI|¯-⊙⋅∘))

# Encode plaintext using the Affine Cipher
Encode ← |3 (
  ¯⌵
  ▽ ⊸(∊ ⊂⊃(+@a⇡26|+@0⇡10))           # Filter letters and digits
  ⍣(⊙(⍤"a and m must be coprime" ⊸CoPrime 26)
    ≡(⨬(∘|E) ⊸∊ LETTERS)             # use precomputed LETTERS
    ▽ ⊸≠@$ /$"_ _" ⬚@$↯∞_5
  | ◌◌◌
  )
)

# Decode plaintext using the Affine Cipher
Decode ← |3 (
  ⍣(⊙(⍤"a and m must be coprime" ⊸CoPrime 26)
    ▽ ⊸≠@\s
    ≡(⨬(∘|D) ⊸∊ LETTERS)             # use precomputed LETTERS
  | ◌◌◌
  )
)
           