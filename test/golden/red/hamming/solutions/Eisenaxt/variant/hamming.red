Red [
	description: {"Hamming" exercise solution for exercism platform}
	author: "Eisenaxt" 
]

distance: function [
	strand1 [string!]
	strand2 [string!]
	return: [integer!]
] [
	if not-equal? length? strand1 length? strand2 [
		do make error! "strands must be of equal length"
	]
	distance: 0
	forall strand1 [
		if not-equal? first strand1 first strand2 [
			distance: distance - 1
		]
		strand2: next strand2
	]
	return distance
]

