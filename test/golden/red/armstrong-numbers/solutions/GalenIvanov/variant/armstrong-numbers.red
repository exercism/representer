Red [
	description: {"Armstrong Numbers" exercise solution for exercism platform}
	author: "Galen Ivanov" 
]

is-armstrong-number: function [number][
	digits: number
    armstrong: 0
    loop len: length? form number [
    	armstrong: digits % 10 ** len + armstrong
		digits: to-integer digits * 10
    ]
    armstrong = number
]