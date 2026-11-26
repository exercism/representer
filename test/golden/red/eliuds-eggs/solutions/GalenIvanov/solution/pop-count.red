Red [
	description: {"Eliud's Eggs" exercise solution for exercism platform}
	author: "Galen Ivanov" 
	comment: "Using recursion"
]

egg-count: function [n][
    either zero? n [0][n // 2 + egg-count n >> 1]
]
