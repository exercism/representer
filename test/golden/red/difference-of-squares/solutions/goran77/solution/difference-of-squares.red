Red [
	description: {"Difference of Squares" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

square-of-sum: function [number] [
	sum: 0
    repeat count number 
    [
    	sum: sum + count
    ]
	sum * sum
]

sum-of-squares: function [number] [
	sum: 0
    repeat count number
    [
    	sum: sum + (count * count)
    ]
	sum
]

difference-of-squares: function [
	number
] [
	s1: square-of-sum number 
    s2: sum-of-squares number
    s1 - s2
]

