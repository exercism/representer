Red [
	description: {"Reverse string" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

reverse: function [
	"Reverses a string"
	input [string!] "String to reverse"
	return: [string!]
] [
	return_string: ""

	foreach char input [
		insert return_string  char
    ]

	return_string
]
