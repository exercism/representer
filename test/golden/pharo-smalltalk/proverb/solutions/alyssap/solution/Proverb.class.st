"
I can tell you a cute little story.
"
Class {
	#name : #Proverb,
	#superclass : #Object,
	#category : #'Exercise@Proverb'
}

{ #category : #'as yet unclassified' }
Proverb >> reciteStrings: aCollection [
	| result |
	result := Stack new.
	aCollection isEmpty and: [ ^ #() ].
	result push: 'And all for the want of a ' , aCollection first , '.'.
	aCollection reversed
		overlappingPairsDo:
			[ :a :b | result push: 'For want of a ' , b , ' the ' , a , ' was lost.' ].
	^ result
]
