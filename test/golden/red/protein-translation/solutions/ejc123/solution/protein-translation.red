Red [
	description: {"Protein Translation" exercise solution for exercism platform}
	author: "@ejc123"
]

; This community solution from @dockimbel is much cleaner and clearer
proteins: function [
	strand
] [
	parse strand [
		collect any [
			  "AUG" keep ("Methionine")
			| ["UUU" | "UUC"] keep ("Phenylalanine")
			| ["UUA" | "UUG"] keep ("Leucine")
			| ["UCU" | "UCC" | "UCA" | "UCG"] keep ("Serine")
			| ["UAU" | "UAC"] keep ("Tyrosine")
			| ["UGU" | "UGC"] keep ("Cysteine")
			| "UGG" keep ("Tryptophan")
			| ["UAA" | "UAG" | "UGA"] end
		]
	]
]

; My original solution

;translation: #(
;    "AUG" "Methionine"
;    "UUU" "Phenylalanine"
;    "UUC" "Phenylalanine"
;    "UUA" "Leucine"
;    "UUG" "Leucine"
;    "UCU" "Serine"
;    "UCC" "Serine"
;    "UCA" "Serine"
;    "UCG" "Serine"
;    "UAU" "Tyrosine"
;    "UAC" "Tyrosine"
;    "UGU" "Cysteine"
;    "UGC" "Cysteine"
;    "UGG" "Tryptophan"
;    "UAA" "STOP"
;    "UAG" "STOP"
;    "UGA" "STOP"
;)
;
;proteins: function [
;	strand
;] [
;  output: copy []
;  until [
;    codon: take/part strand 3
;    protein: translation/:codon
;    if equal? protein "STOP" [break]
;    append output protein
;    empty? strand
;  ]
;  return output
;]