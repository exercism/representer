Class {
	#name : #Robot,
	#superclass : #Object,
	#instVars : [
		'direction',
		'position'
	],
	#classInstVars : [
		'pointZero'
	],
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'as yet unclassified' }
Robot class >> directions [

	^ Dictionary newFrom: { 
			  (0 -> 'north').
			  (1 -> 'east').
			  (2 -> 'south').
			  (3 -> 'west') }
]

{ #category : #initialization }
Robot class >> initialize [

	pointZero := Point x: 0 y: 0
]

{ #category : #accessing }
Robot class >> pointZero [

	^ pointZero
]

{ #category : #'instance creation' }
Robot class >> positioned: aPosition facing: aDirection [
	"Create robot with initial postion and direction"
			
	| robot |
	robot := self new.
	robot positioned: aPosition facing: aDirection.
	^ robot
]

{ #category : #initialization }
Robot class >> setUp [
	"comment stating purpose of class-side method"
	"scope: class-variables  &  class-instance-variables"	
			
	| temporary variable names statements |
	statements
]

{ #category : #accessing }
Robot >> advance [

	position := direction advanceFrom: position 
]

{ #category : #accessing }
Robot >> direction [

	^ direction
]

{ #category : #initialization }
Robot >> initialize [

	position := self class pointZero.
	direction := North
]

{ #category : #accessing }
Robot >> position [

	^ position
]

{ #category : #'instance creation' }
Robot >> positioned: aPosition facing: aDirection [

	"Create robot with initial postion and direction"

	position := aPosition.
	direction := aDirection.
]

{ #category : #accessing }
Robot >> turnLeft [

	direction := direction directionToLeft 
]

{ #category : #accessing }
Robot >> turnRight [

	direction := direction directionToRight 
]
