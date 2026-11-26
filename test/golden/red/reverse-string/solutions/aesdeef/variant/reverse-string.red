Red [
	description: {"Reverse string" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

reverse: function [
	"Reverses a string"
	input [string!] "String to reverse"
	return: [string!]
] [
    output: ""
	repeat i (length? input) [
        append output pick input ((length? input) - 1 - i)
    ]
    output
]
