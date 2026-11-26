Class {
	#name : #Grains,
	#superclass : #Object,
	#category : #'Exercise@Grains'
}

{ #category : #public }
Grains >> atSquare: numberOfSquares [
	self validateNumberOfSquare: numberOfSquares.
	^ 2 ** (numberOfSquares - 1)
]

{ #category : #public }
Grains >> total [
	^ (2 to: (self totalNumberOfSquares))
		sum: [ :i | self atSquare: i ]
]

{ #category : #private }
Grains >> totalNumberOfSquares [
	^ 64
]

{ #category : #private }
Grains >> validateNumberOfSquare: number [
	| errorMessage totalNumberOfSquares |
	
	totalNumberOfSquares := self totalNumberOfSquares.
	errorMessage := 'square must be between 1 and {1}' 
		format: { totalNumberOfSquares }.

	(number between: 1 and: totalNumberOfSquares)
		ifFalse: [ DomainError signal: errorMessage ].
]
