"
A chaining operator that chains a series of opertions on the instruction set.
"
Class {
	#name : #UnaryOperation,
	#superclass : #Object,
	#instVars : [
		'block'
	],
	#category : #'Exercise@Forth'
}

{ #category : #initialization }
UnaryOperation >> performOnStack: aStack [
	| a |
	aStack isEmpty
		ifTrue: [ Error signal: 'empty stack' ].
	a := aStack pop.
	(block value: a) do: [ :each | aStack push: each ]
]

{ #category : #initialization }
UnaryOperation >> withOperationBlock: aBlock [ 
	block := aBlock
]
