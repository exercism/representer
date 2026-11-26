Red [
	description: {"Acronym" exercise solution for exercism platform}
	author: "Eisenaxt" ; you can write your name here, in quotes
]

abbreviate: function [
	phrase [string!]
	return: [string!]
] [
	words-in-phrase: split phrase charset " -_"
	return rejoin collect [
		foreach word words-in-phrase [
			if none <> first word [keep first word]
		]
	]
]

