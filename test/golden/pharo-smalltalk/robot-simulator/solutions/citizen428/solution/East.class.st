Class {
	#name : #East,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #actions }
East >> turnLeft [ 
	^ North new
]

{ #category : #actions }
East >> turnRight [
	^ South new
]
