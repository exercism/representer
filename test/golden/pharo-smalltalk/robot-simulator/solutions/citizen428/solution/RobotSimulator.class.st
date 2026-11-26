Class {
	#name : #RobotSimulator,
	#superclass : #Object,
	#instVars : [
		'direction',
		'position'
	],
	#category : #'Exercise@RobotSimulator'
}

{ #category : #actions }
RobotSimulator >> advance [
	position := position advanceTowards: direction
]

{ #category : #converting }
RobotSimulator >> data [
	^ Dictionary new
		  add: 'direction' -> direction asString;
		  add: 'position' -> position coordinates;
		  yourself
]

{ #category : #'actions lookup' }
RobotSimulator >> sendInstructions: aString [
	aString do: [ :each | self perform: (Instruction parse: each) ].
	^ self data

]

{ #category : #initialization }
RobotSimulator >> startFacing: aString atPosition: aCollection [ 
	direction := Direction fromString: aString.
	position := Position newFrom: aCollection.
	^ self data
]

{ #category : #actions }
RobotSimulator >> turnLeft [
	direction := direction turnLeft
]

{ #category : #actions }
RobotSimulator >> turnRight [
	direction := direction turnRight
]
