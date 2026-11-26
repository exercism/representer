Red [
	description: {"Grains" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

square: function [
	square [integer!]
] [
	if (square <= 1) or (square > 64) [ cause-error 'user 'message "square must be between 1 and 64" ]
	2 ** (square - 1)
]

total: function [] [
	acc: 0
    repeat q 64 [ acc: acc + (square q) ]
	acc
]

