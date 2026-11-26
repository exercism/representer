#+feature dynamic-literals
package protein_translation

@(private)
CODON_TABLE := map[string]u8{
	// Methionine
	"AUG" = 1,
	// Phenylalanine
	"UUU" = 2, "UUC" = 2,
	// Leucine
	"UUA" = 3, "UUG" = 3,
	// Serine
	"UCU" = 4, "UCC" = 4, "UCA" = 4, "UCG" = 4,
	// Tyrosine
	"UAU" = 5, "UAC" = 5,
	// Cysteine
	"UGU" = 6, "UGC" = 6,
	// Tryptophan
	"UGG" = 7,
	// STOP codons
	"UAA" = 9, "UAG" = 9, "UGA" = 9,
}

@(private)
AMINO_ACIDS := [10]string{
	"", // 0 = invalid
	"Methionine",
	"Phenylalanine",
	"Leucine",
	"Serine",
	"Tyrosine",
	"Cysteine",
	"Tryptophan",
	"", // unused
	"", // 9 = STOP
}

proteins :: proc(rna_strand: string) -> ([]string, bool) {
	// Handle empty string
	if len(rna_strand) == 0 {
		return make([]string, 0), true
	}
	
	// Calculate maximum possible proteins (assumes no STOP codons)
	max_proteins := len(rna_strand) / 3
	
	// Pre-allocate with exact capacity to avoid reallocations
	amino_acids := make([dynamic]string, 0, max_proteins)
	stopped_at_stop_codon := false
	
	// Process the RNA strand in chunks of 3 (codons)
	for i := 0; i + 3 <= len(rna_strand); i += 3 {
		// Direct string slice - no copy
		codon := rna_strand[i:i+3]
		
		// Lookup in table (faster than switch for many cases)
		code, found := CODON_TABLE[codon]
		
		if !found {
			// Invalid codon
			delete(amino_acids)
			return nil, false
		}
		
		if code == 9 {
			// STOP codon
			stopped_at_stop_codon = true
			break
		}
		
		// Add the amino acid to the list
		append(&amino_acids, AMINO_ACIDS[code])
	}
	
	// Check if there are remaining characters that couldn't form a complete codon
	// This is only an error if we didn't encounter a STOP codon
	remaining := len(rna_strand) % 3
	if remaining != 0 && !stopped_at_stop_codon {
		// Incomplete sequence without a STOP codon is invalid
		delete(amino_acids)
		return nil, false
	}
	
	// Convert dynamic array to slice
	return amino_acids[:], true
}
      