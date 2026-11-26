# Count the four nucleotides in a DNA string
# Counts ? DNA
Validate ← ⍤"invalid nucleotide in strand" /×∈"ACGT"
NucleotideCounts ← map ⟜(≡/+⊞=) "ACGT" Validate.
