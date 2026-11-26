Red [
	description: {"Raindrops" exercise solution for exercism platform}
	author: "Dan (d2718)"
]

divisor-mapping: [[3 "Pling"] [5 "Plang"] [7 "Plong"]]

append-if-divisible: function [
	accum [string!]
	divisor [integer!]
	check [integer!]
	word [string!]
	return: [string!]
] [
	either (mod check divisor) == 0 [
		rejoin [accum word]
	] [
		accum
	]
]

convert: function [
	number
] [
	output: ""
	foreach pair divisor-mapping [
		output: append-if-divisible output first pair number second pair
	]

	either output = "" [
		to-string number
	] [
		output
	]
]

