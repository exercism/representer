Class {
	#name : #South,
	#superclass : #Direction,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'as yet unclassified' }
South class >> advanceFrom: aPosition [

	^ Point x: aPosition x y: aPosition y - 1
]

{ #category : #printing }
South class >> asString [ 
	
	^ 'south'
]

{ #category : #'as yet unclassified' }
South class >> directionToLeft [
	
	^ East
]

{ #category : #'as yet unclassified' }
South class >> directionToRight [
	
	^ West
]
