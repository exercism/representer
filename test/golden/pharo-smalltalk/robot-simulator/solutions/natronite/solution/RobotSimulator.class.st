Class {
	#name : #RobotSimulator,
	#superclass : #Object,
	#instVars : [
		'robot',
		'instructions'
	],
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'as yet unclassified' }
RobotSimulator >> dictionaryRepresentation: aRobot [

	^ Dictionary new
		  at: 'direction' put: aRobot direction asString;
		  at: 'position' put: (Dictionary new
				   at: 'x' put: aRobot position x;
				   at: 'y' put: aRobot position y;
				   yourself);
		  yourself
]

{ #category : #initialization }
RobotSimulator >> initialize [

	instructions := Dictionary new
		                at: $R put: [ robot turnRight ];
		                at: $L put: [ robot turnLeft ];
		                at: $A put: [ robot advance ];
		                yourself
]

{ #category : #'as yet unclassified' }
RobotSimulator >> sendInstructions: aString [

	"Move robot according to these instructions"

	aString do: [ :c | (instructions at: c) value ].
	^ self dictionaryRepresentation: robot
]

{ #category : #'as yet unclassified' }
RobotSimulator >> startFacing: aDirection atPosition: aPosition [

	"Start the simulation."

	robot := Robot
		         positioned:
		         (Point x: (aPosition at: 'x') y: (aPosition at: 'y'))
		         facing: (Direction for: aDirection).
	^ self dictionaryRepresentation: robot
]
