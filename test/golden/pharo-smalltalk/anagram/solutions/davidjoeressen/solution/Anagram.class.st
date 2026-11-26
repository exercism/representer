Class {
	#name : #Anagram,
	#superclass : #Object,
	#category : #'Exercise@Anagram'
}

{ #category : #'as yet unclassified' }
Anagram >> findAnagramsCandidates: aCollection subject: aString [
	| orderedSubject lowerString |
	lowerString := aString asLowercase.
	orderedSubject := SortedCollection newFrom: lowerString.
	^aCollection select: [ :e |
		| lowerE |
		lowerE := e asLowercase.
		(SortedCollection newFrom: lowerE) = orderedSubject and: [ lowerE ~= lowerString ]
	]
]
