fn count_nucleotides(strand string) !map[string]int {
	mut res := filter[string]int{}
	res['A'] = strand.count('A')
	res['C'] = strand.count('C')
	res['G'] = strand.count('G')
	res['T'] = strand.count('T')
	return if strand.contains_only('ACGT') { res } else { error('X is not a valid nucleotide!') }
}