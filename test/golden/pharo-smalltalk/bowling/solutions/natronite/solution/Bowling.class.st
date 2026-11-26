Class {
	#name : #Bowling,
	#superclass : #Object,
	#category : #'Exercise@Bowling'
}

{ #category : #'as yet unclassified' }
Bowling >> scoreAfterRolling: anArray [

	| frames rolls |
	frames := OrderedCollection new.
	rolls := anArray.

	rolls do: [ :r | 
		r negative ifTrue: [ self error: 'Negative roll is invalid' ].
		r > 10 ifTrue: [ self error: 'Pin count exceeds pins on the lane' ] ].

	[ 
	| frame |
	frame := Frame new: frames size + 1 rolls: rolls.
	rolls := rolls allButFirst: frame rolls.
	frames add: frame.
	frames size < 10 ] whileTrue.

	rolls ifNotEmpty: [ self error: 'Cannot roll after game is over' ].

	^ frames inject: 0 into: [ :sum :frame | sum + frame score ]
]

{ #category : #'as yet unclassified' }
Bowling >> scoreRolling: aNumber after: anArray [

	^ self scoreAfterRolling: anArray , { aNumber }
]
