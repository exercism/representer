"
Just inserts a literal into the stack on call.
"
Class {
	#name : #InsertOperation,
	#superclass : #Object,
	#instVars : [
		'literal'
	],
	#category : #'Exercise@Forth'
}

{ #category : #initialization }
InsertOperation >> performOnStack: aStack [
	aStack push: literal
]

{ #category : #initialization }
InsertOperation >> withLiteral: aLiteral [
	literal := aLiteral
]
