Red [
	description: {"Protein Translation" exercise solution for exercism platform}
	author: "simisc"
]

codons: [
	"UGU" "Cysteine" "UGC" "Cysteine" "UUA" "Leucine" "UUG" "Leucine"
 	"AUG" "Methionine" "UUU" "Phenylalanine" "UUC" "Phenylalanine"
	"UCU" "Serine" "UCC" "Serine" "UCA" "Serine" "UCG" "Serine"
	"UGG" "Tryptophan" "UAU" "Tyrosine" "UAC" "Tyrosine" "UAA" "STOP"
	"UAG" "STOP" "UGA" "STOP"
]

proteins: function [
	strand
] [
	result: copy []
	foreach [a b c] strand [
		protein: select codons rejoin [a b c]
		either protein = "STOP" [break] [append result protein]
	]
	result
]
