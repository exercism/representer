"
I am calculation Grains on a Chessboard
"
Class {
	#name : #Grains,
	#superclass : #Object,
	#category : #'Exercise@Grains'
}

{ #category : #calculating }
Grains >> atSquare: anInteger [
	(anInteger between: 1 and: 64)
		ifFalse: [ Error signal: 'The square must be between 1 and 64' ].
	^ 2 ** (anInteger - 1)
]

{ #category : #computing }
Grains >> total [
	^ 2 ** 64 - 1
]
