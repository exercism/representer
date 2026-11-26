"
A chaining operator that chains a series of opertions on the instruction set.
"
Class {
	#name : #ChainedOperation,
	#superclass : #Object,
	#instVars : [
		'operationChain'
	],
	#category : #'Exercise@Forth'
}

{ #category : #initialization }
ChainedOperation >> performOnStack: aStack [
	operationChain do: [ :operation | operation performOnStack: aStack ]
]

{ #category : #initialization }
ChainedOperation >> withOperationChain: aCollection [
	operationChain := aCollection.
]
