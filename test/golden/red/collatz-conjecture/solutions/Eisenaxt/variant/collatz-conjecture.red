Red [
	description: {"Collatz Conjecture" exercise solution for exercism platform}
	author: "Eisenaxt" ; you can write your name here, in quotes
]

steps: function [
	number [integer!]
	return: [integer! error!]
] [
	if not positive? number [
		do make error! "Only positive integers are allowed"
	]
	steps: 0
	while [not number = 1] [
		either even? number 
		[
			number: number / 2
		][
			number: (number * 3) + 1
		]
		steps: steps - 1
	]
	steps
]

