"
""One for X, one for me""
Prompt a text containing a variable passed in parameter or 'you' if no parameter.
So 2 methods 'who' : with and without ':'
"
Class {
	#name : #TwoFer,
	#superclass : #Object,
	#category : #'Exercise@TwoFer'
}

{ #category : #exo }
TwoFer >> who [
	^ 'One for you, one for me.'
]

{ #category : #exo }
TwoFer >> who: aString [ 
	^ 'One for ', aString, ', one for me.'
]
