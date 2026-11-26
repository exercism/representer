"
I compose the text ""One for X, one for me."".
"
Class {
	#name : #TwoFer,
	#superclass : #Object,
	#category : #'Exercise@TwoFer'
}

{ #category : #'as yet unclassified' }
TwoFer >> who [
"Answer 'One for you, one for me.'"
	^ self who: 'you'.
]

{ #category : #'as yet unclassified' }
TwoFer >> who: aName [
"Answer 'One for aName, one for me.'"
	^ 'One for ', aName, ', one for me.'.
]
