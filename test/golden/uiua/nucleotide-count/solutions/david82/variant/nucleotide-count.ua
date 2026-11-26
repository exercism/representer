# Count the four nucleotides in a DNA string
# Counts ? DNA
Validate ← ⍤"invalid nucleptide in strand" /×∈"ACGT"
NucleotideCounts ← map ⟜(≡/+⊞=) "ACGT" Validate.
