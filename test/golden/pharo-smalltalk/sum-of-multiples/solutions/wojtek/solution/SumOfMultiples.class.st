Class {
	#name : #SumOfMultiples,
	#superclass : #Object,
	#category : #'Exercise@SumOfMultiples'
}

{ #category : #computing }
SumOfMultiples >> sumFactors: factors limit: upTo [
   | temp |
   temp := factors select: [ :each | each > 0 ]
                   thenCollect: [ :item | item to: upTo - 1 by: item ].
   temp := temp inject: (Set empty)
                into: [:sum :each | sum addAll: each. sum ].
   ^temp sumNumbers
]
