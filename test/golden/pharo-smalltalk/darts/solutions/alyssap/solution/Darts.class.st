"
I can score your darts result.
"
Class {
	#name : #Darts,
	#superclass : #Object,
	#category : #'Exercise@Darts'
}

{ #category : #calculating }
Darts >> scoreX: anInteger y: anInteger2 [
	| distance |
	distance := (anInteger @ anInteger2) r.
	distance <= 1
		ifTrue: [ ^ 10 ].
	distance <= 5
		ifTrue: [ ^ 5 ].
	distance <= 10
		ifTrue: [ ^ 1 ].
	^ 0
]
