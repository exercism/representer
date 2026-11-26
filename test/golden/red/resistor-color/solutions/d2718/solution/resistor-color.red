Red [
	description: {"Resistor Color" exercise solution for exercism platform}
	author: "Dan (d2718)"
]

the-colors: ["black" "brown" "red" "orange" "yellow" "green"
			"blue" "violet" "grey" "white"]

color-code: function [
	color [string!]
	return: [integer!]
] [
	(index? find the-colors color) - 1
]

colors: function [] [
	the-colors
]

