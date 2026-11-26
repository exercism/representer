Red [
	description: {"Collatz Conjecture" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

steps: function [n][
	if n < 1 [
    	cause-error 'user 'message "Only positive integers are allowed"
        exit
    ]  
    steps: 0
    while [n > 1][
		n: either odd? n [3 * n + 1][n / 2]
        steps: steps + 1
    ]
    steps
]