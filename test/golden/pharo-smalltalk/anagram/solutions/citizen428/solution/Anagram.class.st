Class {
	#name : #Anagram,
	#superclass : #Object,
	#category : #'Exercise@Anagram'
}

{ #category : #'finding/searching' }
Anagram >> findAnagramsCandidates: aCollection subject: aString [

	| needle |
	needle := aString asLowercase sorted.
	^ aCollection select: [ :each | 
		  (each sameAs: aString) not and: [ 
			  each asLowercase sorted = needle ] ]
]
