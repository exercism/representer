Class {
	#name : #Direction,
	#superclass : #Object,
	#classInstVars : [
		'directions'
	],
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'as yet unclassified' }
Direction class >> advanceFrom: aPosition [
	
	self subclassResponsibility 
]

{ #category : #printing }
Direction class >> asString [ 
	
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
Direction class >> directionToLeft [
	
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
Direction class >> directionToRight [
	
	self subclassResponsibility 
]

{ #category : #'instance creation' }
Direction class >> for: aDirection [

	^ directions at: aDirection
]

{ #category : #initialization }
Direction class >> initialize [

	directions := Dictionary newFrom: { 
			              ('north' -> North).
			              ('east' -> East).
			              ('south' -> South).
			              ('west' -> West) }
]
