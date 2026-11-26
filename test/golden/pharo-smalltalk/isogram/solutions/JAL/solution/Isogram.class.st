Class {
	#name : #Isogram,
	#superclass : #Object,
	#category : #'Exercise@Isogram'
}

{ #category : #actions }
Isogram >> isIsogramPhrase: aString [
	"Considering only letters for the isogram"
	
	| filtered |
	filtered := aString select: [ :e | e isLetter ].
	^ filtered asUppercase asSet size = filtered size
]
