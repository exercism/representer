Red [
	description: {"Darts" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

score: function [
	x
	y
] [
	d: (x * x) + (y * y)
	case [
		d <= 1   [ 10 ]
		d <= 25  [  5 ]
		d < 100 [  1 ]
		true     [  0 ]
    ]
]

