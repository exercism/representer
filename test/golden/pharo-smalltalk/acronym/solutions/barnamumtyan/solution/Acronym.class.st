Class {
	#name : #Acronym,
	#superclass : #Object,
	#instVars : [
		'separators'
	],
	#category : #'Exercise@Acronym'
}

{ #category : #'as yet unclassified' }
Acronym >> abbreviatePhrase: aString [
	^ ((aString substrings: separators)
		collect: [ :word | word first asUppercase ]
		thenSelect: [ :word | word isAlphaNumeric ]) joinUsing: ''
]

{ #category : #initialization }
Acronym >> initialize [
	"initialize separators"

	separators := ' -_'.
]
