Red [
	description: {"Darts" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

score: function [
	x
	y
] [
	distance: square-root (x ** 2) + (y ** 2)
	case [
		distance > 10 [0]
		distance > 5 [1]
		distance > 1 [5]
		true [10]
	]
]

