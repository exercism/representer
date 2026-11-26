"
I'm able to return the points earned by a dart hitting point (x, y).
"
Class {
	#name : #Darts,
	#superclass : #Object,
	#classVars : [
		'Tolerance'
	],
	#category : #'Exercise@Darts'
}

{ #category : #'class initialization' }
Darts class >> initialize [
	Tolerance := 0.001
]

{ #category : #initialization }
Darts >> initialize [
	Tolerance ifNil: [self class initialize] 
]

{ #category : #operations }
Darts >> scoreX: x y: y [
	| distanceToCenter |
	distanceToCenter := (x ** 2 + (y ** 2)) ** 0.5.
	distanceToCenter - 10 > Tolerance
		ifTrue: [ ^ 0 ]
		ifFalse: [ distanceToCenter - 5 > Tolerance 
				ifTrue: [ ^ 1 ]
				ifFalse: [ distanceToCenter - 1 > Tolerance 
						ifTrue: [ ^ 5 ]
						ifFalse: [ ^ 10 ] ] ]
]
