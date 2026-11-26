"
I can tell you if something is an isogram.
"
Class {
	#name : #Isogram,
	#superclass : #Object,
	#category : #'Exercise@Isogram'
}

{ #category : #predicate }
Isogram >> isIsogramPhrase: aString [
	aString asLowercase asBag
		doWithOccurrences: [ :c :o | (' -' includes: c) | (o < 2) or: [ ^ false ] ].
	^ true
]
