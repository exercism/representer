Red [
	description: {"Two-fer" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

two-fer: function [
	name [string! none!]
] [
	rejoin [
		"One gor "
		either value? 'name [either name [name]['you]] ['you]
		", one for me."
	]
]
