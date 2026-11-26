Red [
	description: {"Triangle" exercise solution for exercism platform}
	author: "factor3"
]

triangle?: function [x][
    all reduce [
		x/1 + x/2 > x/3
		x/1 + x/3 > x/2
		x/3 + x/2 > x/1
	]
]

tri?: function [sides n][
	unless triangle? sides [return no]
	if n = length? unique sides [return yes]
	no
]

equilateral: function [sides][tri? sides 1]
isosceles: function [sides][or~ tri? sides 2 equilateral sides]
scalene: function [sides][tri? sides 3]