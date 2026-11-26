Red [
	description: {"Nucleotide Count" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

nucleotide-counts: function [strand][
	seq: #[A: 0 C: 0 G: 0 T: 0]
    foreach c strand [
    	w: to-word c
    	either seq/:w [
        	seq/:w: seq/:w + 1
        ][
    		cause-error 'user 'message "Invalid nucleotide in strand"
    	]    
	]
    seq
]
