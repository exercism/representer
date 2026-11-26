Class {
	#name : #North,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'as yet unclassified' }
North class >> advanceFrom: aPosition [

	^ Point x: aPosition x y: aPosition y + 1
]

{ #category : #printing }
North class >> asString [ 
	
	^ 'north'
]

{ #category : #'as yet unclassified' }
North class >> directionToLeft [
	
	^ West
]

{ #category : #'as yet unclassified' }
North class >> directionToRight [
	
	^ East
]
