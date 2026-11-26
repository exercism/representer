"
# Grains

Calculate the number of grains of wheat on a chessboard given that the number
on each square doubles.

There once was a wise servant who saved the life of a prince. The king
promised to pay whatever the servant could dream up. Knowing that the
king loved chess, the servant told the king he would like to have grains
of wheat. One grain on the first square of a chess board, with the number
of grains doubling on each successive square.

There are 64 squares on a chessboard (where square 1 has one grain, square 2 has two grains, and so on).

Write code that shows:

- how many grains were on a given square, and
- the total number of grains on the chessboard

Public API and Key Messages

- atSquare: anInteger.    
- total.

	Grains new atSquare: 5.
	Grains new total.
	Grains new atSquare: 64. 
	 

"
Class {
	#name : #Grains,
	#superclass : #Object,
	#instVars : [
		'sumOfGrains'
	],
	#category : #'Exercise@Grains'
}

{ #category : #accessing }
Grains >> atSquare: anInteger [
	"how many grains were on a given square"

	self squareNumberIsValid: anInteger.
	anInteger = 1
		ifTrue: [ ^ 1 ].
	"if this is not a first field of chessboard then calculate result recursively"
	^ 2 * (self atSquare: anInteger - 1)
]

{ #category : #validating }
Grains >> squareNumberIsValid: anInteger [
	"chessboard has 64 fields"
	(anInteger between: 1 and: 64)
		ifFalse: [ self error: 'Chessboard square must be between 1 and 64' ].
	^ true
]

{ #category : #accessing }
Grains >> total [
	"the total number of grains on the chessboard
	because sum of grains on the chessboard is a constant value then we can calculate it once and return the result of this calculation in consecutive calls"

	sumOfGrains 
		ifNil: [ sumOfGrains := 0.
			1 to: 64 do: [ :square | sumOfGrains := sumOfGrains + (self atSquare: square) ] ].
	^ sumOfGrains
]
