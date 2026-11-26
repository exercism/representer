Class {
	#name : #SumOfMultiples,
	#superclass : #Object,
	#category : #'Exercise@SumOfMultiples'
}

{ #category : #'as yet unclassified' }
SumOfMultiples >> sumFactors: factors limit: limit [ 
	^ ((factors reject: #isZero)
			flatCollect: [ :factor | factor to: limit - 2 by: factor ])
			asSet sumNumbers
]
