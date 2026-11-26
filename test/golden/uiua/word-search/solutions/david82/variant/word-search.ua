# Extract direction extraction pattern
DirExtract ← ⤸₁≡(⬚@ ↻)

# Extract coordinate processing pattern  
CoordProcess ← ▽⊸≡(≠NaN/+) ♭₂ ×≡⨬NaN1 ⊃(◇⦷⊙⊢|+₁°□⊣◌)

# Extract result processing pattern
ResultProcess ← ▽⊸≡(>₀⧻°□⊣) ♭₂

# Extract mapping pattern
MapCoords ← map ⊃⊏₀(⍚⊃[⊢|⊣] ⊏₁) ⤸₁

# Search for words in a grid
# Findings ? Grid Words
Search ← |3 ◌⍥(⍣⊃(↘₁|insert⊙□:[]⊢))∞ ˜▽⟜⊸≡⌟(¬has°□) ⟜(
  ⊙(
    °⊡ ⬚@ ↯⊸(⊟.⊣△) ⊜∘⊸≠@\n
    ∩⊟₁₂∩⊃(
      DirExtract⇌⇡⊸⧻∘
    | DirExtract⇌×₋₁⇡⊸⧻∘
    | ≡⇌DirExtract×₋₁⇡⊸⧻∘
    | ≡⇌DirExtract⇡⊸⧻∘
    | ≡⇌DirExtract⇌⇡⊸⧻∘
    | ≡⇌DirExtract⇌×₋₁⇡⊸⧻∘
    | DirExtract×₋₁⇡⊸⧻∘
    | DirExtract⇡⊸⧻∘
    | ≡⇌⤸₁ | ⤸₁ | ≡⇌ | ∘
    )
    ≡˜□₂
  )
  ⊞(□₂ ⟜CoordProcess °□)
  ResultProcess
  MapCoords
)
      