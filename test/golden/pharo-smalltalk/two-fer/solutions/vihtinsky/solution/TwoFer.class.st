"
I return strings like 'One for X and one for me' for given name X.
Default value for X is 'you'
"
Class {
	#name : #TwoFer,
	#superclass : #Object,
	#category : #'Exercise@TwoFer'
}

{ #category : #messages }
TwoFer >> who [
   ^ self who: 'you'
]

{ #category : #messages }
TwoFer >> who: name [
    ^ 'One for {1}, one for me.' format: {name}
]
