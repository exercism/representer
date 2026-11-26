Class {
	#name : #East,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'as yet unclassified' }
East class >> advanceFrom: aPosition [

	^ Point x: aPosition x + 1 y: aPosition y
]

{ #category : #printing }
East class >> asString [ 
	
	^ 'east'
]

{ #category : #'as yet unclassified' }
East class >> directionToLeft [
	
	^ North
]

{ #category : #'as yet unclassified' }
East class >> directionToRight [
	
	^ South
]
