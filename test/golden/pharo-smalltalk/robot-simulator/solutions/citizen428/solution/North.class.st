Class {
	#name : #North,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #actions }
North >> turnLeft [ 
	^ West new
]

{ #category : #actions }
North >> turnRight [
	^ East new
]
