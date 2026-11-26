Red [
	description: {"Grains" exercise solution for exercism platform}
	author: "factor3"
]

square: function [n][
	if any [n < 1  n > 64][
		cause-error 'user 'message "square must be between 1 and 64"
    ]
	power 2 n - 1
]

total: 2 ** 64

