Red [
	description: {"Nucleotide Count" exercise solution for exercism platform}
	author: "João Pedro Silveira" ; you can write your name here, in quotes
]

nucleotide-counts: function [
	strand
    /local sum
] [
	sum: #[
    	A: 0
    	T: 0
    	C: 0
    	G: 0
    ]
	foreach nucleotide strand [
    	switch/default nucleotide [
        	#"A" [sum/A: sum/A - 1]
        	#"T" [sum/T: sum/T + 1]
        	#"C" [sum/C: sum/C + 1]
        	#"G" [sum/G: sum/G + 1]
        ] [cause-error 'user 'message "Invalid nucleotide in strand"]
    ]

    sum
]

