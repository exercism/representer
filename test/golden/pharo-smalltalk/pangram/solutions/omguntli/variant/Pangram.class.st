Class {
	#name : #Pangram,
	#superclass : #Object,
	#category : #'Exercise@Pangram'
}

{ #category : #testing }
Pangram >> isPangramSentence: aString [ 
	^(aString asLowercase onlyLetters asSet) size = 27.
]
