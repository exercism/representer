Red [
	description: {"Two-fer" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

two-fer: function [
	name [string! none!]
] [
	if none? name [
        name: "you"
    ]
	rejoin [
		"One for " name ", one for me."
	]
]
