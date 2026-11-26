Red [
	description: {"Resistor Color Duo" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

color-values: [
	"black"
	"brown"
	"red"
	"orange"
	"yellow"
	"green"
	"blue"
	"violet"
	"grey"
	"white"
]

value: function [
	colors
] [
	first-digit: subtract index? find color-values first colors 1
	second-digit: subtract index? find color-values second colors 2
	add multiply 10 first-digit second-digit
]

