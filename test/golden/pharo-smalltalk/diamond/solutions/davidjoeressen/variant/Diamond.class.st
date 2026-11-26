Class {
	#name : #Diamond,
	#superclass : #Object,
	#category : #'Exercise@Diamond'
}

{ #category : #'as yet unclassified' }
Diamond >> generateRow: aCharacter withPadding: anInteger [
	| i |
	i := aCharacter asciiValue - $A asciiValue.
	^self mirror: (String streamContents: [ :s |
		s nextPutAll: (' ' repeat: anInteger - i).
		s nextPut: aCharacter.
		s nextPutAll: (' ' repeat: i).
	])
]

{ #category : #'as yet unclassified' }
Diamond >> mirror: aCollection [
	| out |
	out := aCollection class new: aCollection size * 2 - 1.
	aCollection withIndexDo: [ :e :i |
		out at: i put: e.
		out at: out size + 2 - i put: e.
	].
	^out.
]

{ #category : #'as yet unclassified' }
Diamond >> rowsLetter: aString [ 
	| padding letter |
	letter := aString first.
	padding := letter asciiValue - $A asciiValue.
	^self mirror: (($A to: letter) collect: [ :c | self generateRow: c withPadding: padding ])
]
