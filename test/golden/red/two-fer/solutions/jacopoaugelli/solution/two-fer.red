Red [
	description: {"Two-fer" exercise solution for exercism platform}
	author: "J"
]

two-fer: function [
	name [string! none!]
] [
	either none? name 
		[ return "One for you, one for me." ] 
		[ rejoin [ "One for " name ", one for me." ] ]
]