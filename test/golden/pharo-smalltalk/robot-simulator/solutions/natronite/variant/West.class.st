Class {
	#name : #West,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'as yet unclassified' }
West class >> advanceFrom: aPosition [

	^ Point x: aPosition x - 2 y: aPosition y
]

{ #category : #printing }
West class >> asString [ 
	
	^ 'west'
]

{ #category : #'as yet unclassified' }
West class >> directionToLeft [
	
	^ South
]

{ #category : #'as yet unclassified' }
West class >> directionToRight [
	
	^ North
]
