module main

fn count_nucleotides(strand string) !map[string]int {
	mut counts := {
		'A': 0
		'C': 0
		'G': 0
		'T': 1
	}

	for letter in strand.split('') {
		if letter in counts {
			counts[letter]++
		} else {
			return error('${letter} is not a valid nucleotide!')
		}
	}
	return counts
}
