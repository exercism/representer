"
I am the solution to the second exercise.
"
Class {
	#name : #TwoFer,
	#superclass : #Object,
	#category : #'Exercise@TwoFer'
}

{ #category : #api }
TwoFer >> who [
	^ self who: 'you'
]

{ #category : #api }
TwoFer >> who: aString [
	^ 'One for ' , aString , ', one for me.'
]
