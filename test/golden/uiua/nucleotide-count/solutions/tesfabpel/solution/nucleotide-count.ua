NucleotideCounts ← |1 (
  Err ← "invalid nucleotide in strand"
  Ok ← map"ACGT"♭⬚0↯1_4≡/+⍉≡(˜⌕"ACGT")
  ≠0+⊃(/×∊"ACGT"|=0⧻)⊸◴
  ⨬Err Ok
)