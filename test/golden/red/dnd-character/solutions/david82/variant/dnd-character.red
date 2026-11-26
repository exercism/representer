Red [
    description: {"D&D Character" exercise solution for exercism platform"}
    author: "David82"
]

; Function to calculate the ability modifier
modifier: function [
	score
] [
	;cause-error 'user 'message "You need to implement modifier function."
    to integer! round/floor (score - 10 / 2)
]

ability: function [] [
    rolls: copy []
    loop 4 [append rolls random 6]
    sort/reverse rolls
    take/last rolls
    sum rolls
]

; Function to create a new character with random abilities
new-character: function [] [
	ch: make map! []
    ch/strength: ability
    ch/dexterity: ability
    ch/constitution: ability
    ch/intelligence: ability
    ch/wisdom: ability
    ch/charisma: ability
    ch/hitpoints: 10 + modifier ch/constitution
    ch
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

	(is-valid char/strength)
	and (is-valid char/dexterity)
	and (is-valid char/constitution)
	and (is-valid char/intelligence)
	and (is-valid char/wisdom)
	and (char/hitpoints == (10 + modifier char/constitution))
]
