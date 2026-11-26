package strand

// ToRNA convert to rna on the given DNA
func ToRNA(dna string) string {
	rna := ""
	for _, v := range dna {
		switch v {
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
