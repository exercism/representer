Red [
	description: {"Raindrops" exercise solution for exercism platform}
	author: "David Stockton" ; you can write your name here, in quotes
]

convert: function [
	"Generates rain sounds based on a number"
	number [integer!]
	return: [string!]
] [
	output: ""
	case/all [
		number % 3 == 0 [ append output "Pling"]
		number % 5 == 0 [ append output "Plang"]
		number % 7 == 0 [ append output "Plong"]
		empty? output [append output to string! number]
    ]
	output
]

