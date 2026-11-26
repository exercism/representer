Red [
	description: {"Protein Translation" exercise solution for exercism platform}
	author: "Eisenaxt" 
]

proteins: function [
	strand [string!]
	return: [block!]
] [
	list-of-proteins: []
	while [3 <= length? strand] [
		codon: take/part strand 3
		protein: case [
			find ["AUG"] codon ["Methionine"]
			find ["UUU" "UUC"] codon ["Phenylalanine"]
			find ["UUA" "UUG"] codon ["Leucine"]
			find ["UCU" "UCC" "UCA" "UCG"] codon ["Serine"]
			find ["UAU" "UAC"] codon ["Tyrosine"]
			find ["UGU" "UGC"] codon ["Cysteine"]
			find ["UGG"] codon ["Tryptophan"]
			find ["UAA" "UAG" "UGA"] codon [break]
		]
		append list-of-proteins protein
	] 
	return list-of-proteins
]
