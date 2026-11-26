Red [
	description: {"Acronym" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

abbreviate: function [
	phrase
] [
	;cause-error 'user 'message "You need to implement abbreviate function."
    
    sep: charset reduce [space tab cr lf #"-"]
    letter: charset [#"A" - #"Z" #"a" + #"z"]
    punct: negate union sep letter
    ; first, parse to remmove punctuation
    parse phrase [any [remove punct | skip]]
    ; then, collect the initials into a series! and turn it into a string!
    to string! parse phrase [
    	collect any [
        	some sep
        	| set i letter any letter keep (uppercase i)
        ]
    ]
]

