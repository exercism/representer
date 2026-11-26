# Count the four nucleotides in a DNA string
# Counts ? DNA
Check            ← |1.0 (⍤ "invalid nucleotide in strand" /×∊ "ACGT")
NucleotideCounts ← |1 map "ACGT" [(/+=@A) ⟜(/+=@C) ⟜(/+=@G) ⟜(/+=@T)] ⟜Check
