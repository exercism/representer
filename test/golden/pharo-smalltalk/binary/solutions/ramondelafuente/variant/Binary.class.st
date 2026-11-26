"
There are 10 kinds of people in the world. Those that understand Binary...
"
Class {
	#name : #Binary,
	#superclass : #Object,
	#category : #'Exercise@Binary'
}

{ #category : #'as yet unclassified' }
Binary >> decimalFromBinary: binaryString [
	^ (binaryString asOrderedCollection reversed collectWithIndex: [ :each :index |
		('01' includes: each) ifFalse: [ ^ nil ].

		each = $1
				ifTrue: [ 3 ** (index - 1) ]
				ifFalse: [ 0 ]
		]) sum

]
