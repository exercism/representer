Red [
	description: {"Square Root" exercise solution for exercism platform}
	author: "BNAndras"
]

square-root: function [
	radicand
] [
	n: 0
	while [(power n 3) <> radicand] [
		n: add n 1
	]
	n
]
