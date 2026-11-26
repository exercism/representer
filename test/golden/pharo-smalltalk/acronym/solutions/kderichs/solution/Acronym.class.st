Class {
	#name : #Acronym,
	#superclass : #Object,
	#category : #'Exercise@Acronym'
}

{ #category : #'as yet unclassified' }
Acronym >> abbreviatePhrase: aString [

	| abreviation |
	abreviation := WriteStream on: String new.
	(aString substrings: ' _-') do: [ :word | 
		abreviation nextPutAll: (word first: 1) asUppercase  ].
	^ abreviation contents
]
