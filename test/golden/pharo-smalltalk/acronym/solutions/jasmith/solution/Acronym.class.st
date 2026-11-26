Class {
	#name : #Acronym,
	#superclass : #Object,
	#category : #'Exercise@Acronym'
}

{ #category : #exercise }
Acronym >> abbreviatePhrase: aString [ 
	"Answer a String composed of the first letter of each word up-cased"
	
	| words initials |
	words := aString allRegexMatches: '[a-zA-Z][a-zA-Z'']*'.
	initials := words collect: #first.
	^('' join: initials) asUppercase 
]
