Red [
	description: {"D&D Character" exercise solution for exercism platform}
	author: "tryska" ; you can write your name here, in quotes
]

modifier: function [
	score
] [
	val: (score - 10) / 2
    either val < 0 [
        to-integer val - 0.9999999  ;
    ][
        to-integer val              ;
    ]
]

ability: function [] [
	random/seed now
    lancers: collect [
        repeat i 4 [
            keep random 6
        ]
    ]

    lancers: sort/reverse lancers
    
    meilleurs: copy/part lancers 3

    total: 0
    foreach val meilleurs [total: total + val]

    total
]

new-character: function [] [
	make object! [
    	strength: ability
        dexterity: ability
        constitution: ability
        intelligence: ability
        wisdom: ability
        charisma: ability
        hitpoints: 10 + modifier constitution
    ]
]

; Don't edit the following functions used by the test suite

test-ability: function [] [
	is-valid ability
]

is-valid: function [
	score
] [
	(score >= 3) and (score < 18)
]

test-random-character-valid: function [] [
	char: new-character

    print ["char =" char]
    print ["strength =" char/strength]
	(is-valid char/strength)
	and (is-valid char/dexterity)
	and (is-valid char/constitution)
	and (is-valid char/intelligence)
	and (is-valid char/wisdom)
	and (char/hitpoints == (10 + modifier char/constitution))
]
