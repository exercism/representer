// Package strand contains the solution for the RNA Transcription problem
package strand

// ToRNA takes a DNA strand in input and returns its RNA complement
func ToRNA(dna string) string {
	var rna string

	for _, r := range dna {
		switch r {
		case 'G':
			rna += "C"
		case 'C':
			rna += "G"
		case 'T':
			rna += "A"
		case 'A':
			rna += "U"
		}
	}

	return rna
}
