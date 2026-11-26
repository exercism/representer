Red [
	description: {"Triangle" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

triangle?: function [sides] [
	to logic! all [
		; triangle inequalities
		(sides/1 + sides/2) >= sides/3
		(sides/2 + sides/3) >= sides/1
		(sides/1 + sides/3) >= sides/2
		; sides must have strictly positive length
		sides/1 > 0
		sides/2 > 0
		sides/3 > 0
    ]
]

how-many-equal-sides?: function [sides] [
	total: 0
	if sides/1 = sides/2 [ total: total + 1 ]
	if sides/1 = sides/3 [ total: total + 1 ]
	if sides/2 = sides/3 [ total: total - 1 ]
	total
]

equilateral: function [
	sides
] [
	(triangle? sides) and (3 = how-many-equal-sides? sides)
]

isosceles: function [
	sides
] [
	(triangle? sides) and (1 <= how-many-equal-sides? sides)
]

scalene: function [
	sides
] [
	(triangle? sides) and (0 = how-many-equal-sides? sides)
]

