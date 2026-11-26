Red [
	description: {"Allergies" exercise solution for exercism platform}
	author: "" ; you can write your name here, in quotes
]

allergies: ["eggs" "peanuts" "shellfish" "strawberries" "tomatoes" "chocolate" "pollen" "cats"]

allergy-to-score: make map! collect [
	repeat i length? allergies [
    	keep reduce [pick allergies i  1 << (i - 1)]
    ]
]

allergic-to: function [
	item
	score
] [
	mask: select allergy-to-score item
    score and mask <> 0
]

list: function [
	score
] [
    collect [
    	foreach item allergies [
        	if allergic-to item score [
            	keep item
            ]
        ]
    ]
]

