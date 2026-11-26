Class {
	#name : #Proverb,
	#superclass : #Object,
	#category : #'Exercise@Proverb'
}

{ #category : #'string-manjpulation' }
Proverb >> reciteOnlyForFirst: firstWord [

	^ 'And all for the want of a ', firstWord , '.'
		
]

{ #category : #'string-manipulation' }
Proverb >> reciteRhymeForFirst: firstWord andSecond: secondWord [

	^ 'For want of a ', firstWord, ' the ', secondWord, ' was lost.'
		
]

{ #category : #'string-manipulation' }
Proverb >> reciteStrings: collectionOfWords [
	| resultCollection |
	resultCollection := OrderedCollection new.
	collectionOfWords
		overlappingPairsDo: [ :firstWord :secondWord | 
			resultCollection
				add: (self reciteRhymeForFirst: firstWord andSecond: secondWord) ].
	collectionOfWords
		ifNotEmpty: [ resultCollection
				add: (self reciteOnlyForFirst: collectionOfWords first) ].
	^ resultCollection asArray
]
