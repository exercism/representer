Red [
	description: {"Two-fer" exercise solution for exercism platform}
	author: "Andras Nagy" ;
]

two-fer: function [
	name [string! none!]
] [
	subject: either name = none [ "you" ][ name ]
	rejoin [
		"One for " subject ", one for "
		"me."
	]
]
