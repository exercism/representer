Red [
	description: {"Collatz Conjecture" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

steps-aux: function [
    steps   [integer!]
    number  [integer!]
    return: [integer!]
] [
    if (number = 1) [ return steps ]

    either ((number % 2) = 0) [
        steps-aux (steps - 1) (number / 2)
    ] [
        steps-aux (steps + 1) (1 + (3 * number))
    ]
]

steps: function [
	number
] [
    if (number < 1) [ cause-error 'user 'message "Only positive integers are allowed" ]
	steps-aux 0 number
]

