# Cleanup and validate a phone number
# Cleaned ? Uncleaned
Clean ← |1 ⍣(
  ⍤"invalid character"=0⧻⊸(regex"[^\\d\\(\\) -\\.]")
  ⋕♭regex"\\d"
  ⍤"invalid length"×⊃≥₁₀≤₁₁⊸⧻
  ⨬(∘|⍤"invalid country code"=1°⊂)=12⊸⧻
  ⍤"invalid area code">1⊸⊢
  ⍤"invalid exchange code">1⊸⊡₃
  /$"__"
)⋅∘
