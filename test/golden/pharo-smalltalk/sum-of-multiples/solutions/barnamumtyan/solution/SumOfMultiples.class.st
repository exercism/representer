Class {
	#name : #SumOfMultiples,
	#superclass : #Object,
	#category : #'Exercise@SumOfMultiples'
}

{ #category : #'as yet unclassified' }
SumOfMultiples >> sumFactors: aCollection limit: anInteger [
	| multiplesUpToLimit |
	multiplesUpToLimit := aCollection
		reject: [ :factor | factor < 1 ]
		thenCollect:
			[ :factor | (0 to: (anInteger - 1) // factor) collect: [ :index | index * factor ] ].
	^ multiplesUpToLimit flattened asOrderedCollection removeDuplicates
		sumNumbers
]
