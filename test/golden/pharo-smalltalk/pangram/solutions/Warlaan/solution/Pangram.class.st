Class {
	#name : #Pangram,
	#superclass : #Object,
	#category : #'Exercise@Pangram'
}

{ #category : #preparation }
Pangram >> isPangramSentence: aString [
	^ aString onlyLetters asLowercase asSet
		= Character alphabet asSet
]
