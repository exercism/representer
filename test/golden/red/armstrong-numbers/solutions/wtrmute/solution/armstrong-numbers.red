Red [
	description: {"Armstrong Numbers" exercise solution for exercism platform}
	author: "Wtrmute" ; you can write your name here, in quotes
]

is-armstrong-number: function [
	number
] [
	if number = 0 [return true]
    n: number
    digits: []
    while [n > 0] [
    	d: n % 10
        append digits d
        n: (n - d) / 10
    ]
    xp: length? digits
    sum: 0
    foreach digit digits [
    	sum: sum + (digit ** xp)
    ]
    sum = number
]

