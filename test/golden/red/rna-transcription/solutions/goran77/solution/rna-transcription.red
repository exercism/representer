Red [
	description: {"RNA Transcription" exercise solution for exercism platform}
	author: "goran77" ; you can write your name here, in quotes
]

to-rna: function [dna] [
replacements: [["A" "U"]["T" "A"]["C" "X"]["G" "C"]["X" "G"]]
 
foreach rep replacements[
  	replace/all dna (first rep) (second rep)
]

]



