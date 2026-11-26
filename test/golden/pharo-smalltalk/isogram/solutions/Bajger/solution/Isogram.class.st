Class {
	#name : #Isogram,
	#superclass : #Object,
	#category : #'Exercise@Isogram'
}

{ #category : #testing }
Isogram >> isIsogramPhrase: aString [
	| aBag |
	"reject all characters that contain $- and spaces and make bag from lowercase characters,
	 to calculate occurences. Return true, if ocurrence of all characters in bag is not more than 1.
	"
	aBag := (aString
		reject: [ :char | char = $- or: [ char = Character space ] ]
		thenCollect: [ :char | char asLowercase ]) asBag.
	^ aBag
		noneSatisfy: [ :character | (aBag occurrencesOf: character) > 1 ]
]
