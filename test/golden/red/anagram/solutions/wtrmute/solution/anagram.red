Red [
	description: {"Anagram" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

find-anagrams: function [
	subject
	candidates
] [
    ls: lowercase copy subject
    ss: sort copy subject
    collect [foreach candidate candidates [
    	lc: lowercase copy candidate
        sc: sort copy candidate
        if (sc = ss) and not (lc = ls) [keep candidate]
    ]]
]

