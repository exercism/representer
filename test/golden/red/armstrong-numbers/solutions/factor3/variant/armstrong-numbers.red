Red []
is-armstrong-number: function [number][
	n: number
	digits: copy []
    while [n > 0][
    	insert digits n % 10
        n: to-integer n / 10
    ]
    len: length? digits
    foreach x digits [
    	n: x ** len - n
    ]
    number = n
]