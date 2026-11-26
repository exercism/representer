// Package strand returns the RNA transcription of a DNA strand.
package strand

// ToRNA returns a string representation of the RNA transcription of its input.
func ToRNA(dna string) string {
	rna := ""
	for _, s := range dna {
		switch s {
		case 'C':
			rna = rna + string("G")
		case 'G':
			rna = rna + string("C")
		case 'T':
			rna = rna + string("A")
		case 'A':
			rna = rna + string("U")
		}
	}
	return rna
}
