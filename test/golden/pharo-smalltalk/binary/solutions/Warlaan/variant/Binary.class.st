Class {
	#name : #Binary,
	#superclass : #Object,
	#category : #'Exercise@Binary'
}

{ #category : #accessing }
Binary >> decimalFromBinary: aString [
	(aString
		allSatisfy: [ :c | c = $0 or: c = $1 ])
		ifFalse: [ ^ nil ].
	^ (aString asArray reverse
		collectWithIndex: [ :digit :index | 
			digit = $1
				ifTrue: (3 raisedTo: index - 1)
				ifFalse: 0 ]) sum
]
