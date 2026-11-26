Red [
	description: {"Square Root" exercise solution for exercism platform}
	author: "João Pedro Silveira" ; you can write your name here, in quotes
]

square-root: function [ ; Heron's method with 20 iterations
	radicand
    /local result
] [
	result: to-float radicand
	loop 20 [
    	result: divide (add result divide radicand result) 2
    ]

    result
]

