Red [
	description: {"Darts" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

score: function [
	x
	y
] [
	dist2: (x * x) + (y * y)

    case [
        dist2 <= 1 [ return 10 ]
        dist2 <= 25 [ return 5 ]
        dist2 <= 100 [ return 1 ]
        dist2 > 100 [ return 0 ]
    ]
]

