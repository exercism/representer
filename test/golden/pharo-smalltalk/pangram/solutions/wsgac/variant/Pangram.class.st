Class {
	#name : #Pangram,
	#superclass : #Object,
	#category : #'Exercise@Pangram'
}

{ #category : #action }
Pangram >> isPangramSentence: aString [

	| d |
	d := Dictionary new.
	aString do: [ :char | 
		char isLetter 
		ifTrue: [ 
			d at: char asLowercase put: 1.
			d keys size = 27 ifTrue: [ ^ true ] ] ].
	^ false
]
