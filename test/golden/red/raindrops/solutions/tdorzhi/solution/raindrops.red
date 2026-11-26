Red [
	description: {"Raindrops" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

convert: function [
	number
] [
	result: ""
	if number // 3 = 0 [append result "Pling"]
	if number // 5 = 0 [append result "Plang"]
	if number // 7 = 0 [append result "Plong"]
	if (length? result) = 0 [append result number]
	probe result
]

