Class {
	#name : #Direction,
	#superclass : #Object,
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'instance creation' }
Direction class >> fromString: aString [
	^ aString capitalized asClass new
]

{ #category : #converting }
Direction >> asString [
	^ self class name asLowercase
]

{ #category : #actions }
Direction >> turnLeft [ 
	self subclassResponsibility
]

{ #category : #actions }
Direction >> turnRight [
	self subclassResponsibility
]
