Class {
	#name : #Instruction,
	#superclass : #Object,
	#classVars : [
		'Mapping'
	],
	#category : #'Exercise@RobotSimulator'
}

{ #category : #parsing }
Instruction class >> mapping [
	Mapping ifNil: [ 
		Mapping := Dictionary newFrom: { 
				           ($R -> #turnRight).
				           ($L -> #turnLeft).
				           ($A -> #advance) } ].
	^ Mapping
]

{ #category : #parsing }
Instruction class >> parse: aString [
	^ self mapping at: aString
]
