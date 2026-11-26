# Encode a string using run-length encoding
# Split ← ⬚"" ⌝▽⟜▽ ⊙°⋕ ⊸≠1 °▽
# Originally I wanted to use anti keep here because the phrase then uses keep in all
# forms, which I liked. However I see that anti keep was added only 9 days ago.
Split = ⬚""⌝⊏▽:⊃(°⊏|▽)⊙°⋕ ⊸≠1 °▽

# Ciphertext ? Plaintext
Encode ← ⨬(""|⍥(/◇⊂) 2 ⍉⬚""⊟ Split) >0 ⊸⧻

# Decode a string encoded with run-length encoding
Pat ← ⬚"1" regex "(\\d+)?(\\w|\\s)"

# Plaintext ? Ciphertext
Decode ← ⨬(""|/◇⊂ ▽ ⋕°⊟⍉ ≡↘1 Pat) >0 ⊸⧻
