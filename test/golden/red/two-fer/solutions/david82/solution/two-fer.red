Red [
	description: {"Two-fer" exercise solution for exercism platform}
	author: "David82"
]

two-fer: function [
	name [string! none!]
] [
    person: either name = none [ "you" ][ name ]
	rejoin [
		"One for " person ", one for "
		"me."
	]
]
