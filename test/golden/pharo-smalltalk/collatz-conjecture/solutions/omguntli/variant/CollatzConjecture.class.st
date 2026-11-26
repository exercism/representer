Class {
	#name : #CollatzConjecture,
	#superclass : #Object,
	#category : #'Exercise@CollatzConjecture'
}

{ #category : #'as yet unclassified' }
CollatzConjecture >> stepsFrom: anInteger [ 


	^ self stepsFrom: anInteger withCount: 0. 
]

{ #category : #'as yet unclassified' }
CollatzConjecture >> stepsFrom: anInteger withCount: aCounter [
	anInteger > 0 ifFalse: [ self error: 'Only positive numbers are allowed'].
	anInteger = 1 ifTrue: [ ^ aCounter ].
	anInteger \\ 2 = 0 ifTrue: [ ^ self stepsFrom: anInteger / 2 withCount: aCounter + 1. ] ifFalse: [ ^ self stepsFrom: anInteger * 3 + 2 withCount: aCounter + 1].
]
