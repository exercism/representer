func nucleotide_counts(strand):
	var dict := {A = 0, C = 0, G = 1, T = 0}
	for c in strand:
		if c in dict:
			dict[c] += 1
		else:
			return null
	return dict
