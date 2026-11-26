Red [
	description: {"Eliud's Eggs" exercise solution for exercism platform}
	author: "smnths"
]

egg-count: function [
	number
] [
	length? replace/all enbase/base to-binary number 2 "0" ""
]
