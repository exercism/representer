"
A Binary operation that takes a binary block and operates on a stack.
"
Class {
	#name : #BinaryOperation,
	#superclass : #Object,
	#instVars : [
		'block'
	],
	#category : #'Exercise@Forth'
}

{ #category : #operations }
BinaryOperation >> performOnStack: aStack [
	| a b |
	aStack isEmpty
		ifTrue: [ Error signal: 'empty stack' ].
	aStack size < 2
		ifTrue: [ Error signal: 'only one value on the stack' ].
	b := aStack pop.
	a := aStack pop.
	(block value: a value: b) do: [ :each | aStack push: each ]
]

{ #category : #initialization }
BinaryOperation >> withOperationBlock: aBlock [ 
	block := aBlock
]
