"
Simple class for calculating sum of multiples
"
Class {
	#name : #SumOfMultiples,
	#superclass : #Object,
	#category : #'Exercise@SumOfMultiples'
}

{ #category : #private }
SumOfMultiples >> makeFilter: anArray [
 "Create a filter from an array of divisors. This return a block
  with a parameter. This block check if a number is divisible by any
 of the numbers in the array."
 ^ [ :n |  
			(anArray 
				collect: 
					[ :divisor  | n isDivisibleBy: divisor ]) 
				inject: false into: 
					[ :acc :each | acc or: each ]]
]

{ #category : #actions }
SumOfMultiples >> sumFactors: aCollection limit: anInteger [ 
	"First we create a filter with the collection and after we use for 
	filtering and sum all values"
	
  | filter |
  filter := self makeFilter: aCollection.
  ^ ((1 to: anInteger - 1) 
				select: filter) 
			inject: 0 into:  
				[ :acc :each | acc +  each ]
]
