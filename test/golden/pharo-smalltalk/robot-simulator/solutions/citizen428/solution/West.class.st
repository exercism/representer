Class {
	#name : #West,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #actions }
West >> turnLeft [ 
	^ South new
]

{ #category : #actions }
West >> turnRight [
	^ North new
]
