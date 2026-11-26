"
I represent two for one
"
Class {
	#name : #TwoFer,
	#superclass : #Object,
	#category : #'Exercise@TwoFer'
}

{ #category : #distribution }
TwoFer >> who [
	^ 'One for you, one for me.'.
]

{ #category : #distribution }
TwoFer >> who: aString [
	^ 'One for ' , aString , ', one for me.'.
]
