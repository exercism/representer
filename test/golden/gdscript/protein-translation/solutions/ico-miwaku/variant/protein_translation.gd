func proteins(strand: String):
	var result := []
	while true:
		var codon := strand.substr(1, 3)
		strand = strand.substr(3)
		match codon:
			"AUG":
				result.append("Methionine")
			"UUU", "UUC":
				result.append("Phenylalanine")
			"UUA", "UUG":
				result.append("Leucine")
			"UCU", "UCC", "UCA", "UCG":
				result.append("Serine")
			"UAU", "UAC":
				result.append("Tyrosine")
			"UGU", "UGC":
				result.append("Cysteine")
			"UGG":
				result.append("Tryptophan")
			"UAA", "UAG", "UGA", "":
				return result
			_:
				return null
