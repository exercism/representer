Class {
	#name : #South,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #actions }
South >> turnLeft [ 
	^ East new
]

{ #category : #actions }
South >> turnRight [
	^ West new
]
