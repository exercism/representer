Class {
	#name : #SumOfMultiples,
	#superclass : #Object,
	#category : #'Exercise@SumOfMultiples'
}

{ #category : #'as yet unclassified' }
SumOfMultiples >> sumFactors: multiples  limit: aLimit [ 

	| numbers sum |
	
	sum := 0.
	numbers := Set new.

	aLimit > 0
		ifTrue: [ 
  			1 to: (aLimit - 1) do: [:each | 
				multiples do: [:el | |check| (el ~= 0)
					           ifTrue: [(check := (each \\ el )) = 0
		                            ifTrue: [numbers add: each]]]]].
													
	^sum := numbers sumNumbers.
]
