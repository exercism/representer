DropSpaces ← |1 ⨬(∘|DropSpaces ↘ ¯1) =@  ⊸⊣
# Implement the encoding process for the Atbash cipher
# Ciphertext ? Plaintext
Encode ← |1 DropSpaces /$"_ _" ⬚@ ↯ ⇌⊂ 5 ⊸(⌈÷5⧻) ⟜⧻ ⨬(∘|+@a +1 ˜-26 -@a) ⊸(≠0±) ▽ ↥⊙↧ ⊸⊃(≠0±|≥@0|≤@9) ×¯1 ⌵

# Implement the decoding process for the Atbash cipher
# Plaintext ? Ciphertext
Decode ← |1 keep by ne @  Encode
