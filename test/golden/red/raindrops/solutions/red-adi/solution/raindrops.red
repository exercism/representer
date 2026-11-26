Red [
	description: {"Raindrops" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

convert: function [
	number
] [
	sound: make string! ""
	case/all [
		(mod number 3) = 0	[append sound "Pling"]
		(mod number 5) = 0	[append sound "Plang"]
		(mod number 7) = 0	[append sound "Plong"]
	]
	if sound = "" [sound: to-string number]
	return sound
]

