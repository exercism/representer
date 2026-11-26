"
I am a tester for whether strings are isograms.
"
Class {
	#name : #Isogram,
	#superclass : #Object,
	#category : #'Exercise@Isogram'
}

{ #category : #testing }
Isogram >> isIsogramPhrase: aString [
	| onlyLetters |
	onlyLetters := aString onlyLetters.
	^ onlyLetters asLowercase asSet size = onlyLetters size
]
