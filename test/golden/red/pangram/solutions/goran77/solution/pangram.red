Red [
	description: {"Pangram" exercise solution for exercism platform}
	author: "goran77" ; you can write your name here, in quotes
]

is-pangram: function [
	sentence
] [
	alphabet: make bitset! [#"A" - #"Z"] 
    sentence: make bitset! uppercase sentence
    alphabet = intersect alphabet sentence
]

