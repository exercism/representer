Red [
	description: {"Raindrops" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

convert: function [
	number
] [
	sound: ""
	if (number % 3 == 0) [sound: rejoin [sound "Pling"]]
	if (number % 5 == 0) [sound: rejoin [sound "Plang"]]
	if (number % 7 == 0) [sound: rejoin [sound "Plong"]]
	if ((length? sound) == 0) [sound: to string! number]
	sound
]

