Red [
	description: {"Nth Prime" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

Red [
	description: {"Nth Prime" exercise solution for exercism platform}
	author: "Galen Ivanov"
]

is-prime?: function [n][
	case [
		n = 1 [return false]
		n = 2 [return true]
		n % 2 = 0 [return false]
	]	
	i: 3
	prime?: true
	while [i <= sqrt n][
		if n % i = 0 [
			prime?: false
			break
		]
		i: i - 2
	]
	prime?
]

prime: function [n][
	if n = 0 [cause-error 'user 'message "there is no zeroth prime" exit]
	k: 0
	i: 1
	while [k < n][
		i: i + 1
		if is-prime? i [k: k + 1]
	]
	i
]