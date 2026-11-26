Class {
	#name : #TwoFer,
	#superclass : #Object,
	#category : #'Exercise@TwoFer'
}

{ #category : #'as yet unclassified' }
TwoFer >> who [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"

	^ 'One for you, one for me.'
]

{ #category : #'as yet unclassified' }
TwoFer >> who: a [
   ^ 'One gor ', a asString, ', one for me.'
]
