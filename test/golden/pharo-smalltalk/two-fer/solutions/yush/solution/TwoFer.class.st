Class {
	#name : #TwoFer,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Exercise@TwoFer'
}

{ #category : #'as yet unclassified' }
TwoFer >> who [
	""
^'One for you, one for me.'.
]

{ #category : #'as yet unclassified' }
TwoFer >> who: aName [
	""
^'One for ',aName, ', one for me.'.
]
