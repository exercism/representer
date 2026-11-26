Class {
	#name : #MatchingBrackets,
	#superclass : #Object,
	#category : #'Exercise@MatchingBrackets'
}

{ #category : #api }
MatchingBrackets >> isPaired: aString [
	| dict stk myBlock |
	stk := Stack new.
	"myBlock checks the top of the stack on char c"
	myBlock := [ :c | 
	stk isEmpty
		ifTrue: [ ^ false ].
	stk top ~= c
		ifFalse: [ stk pop ]
		ifTrue: [ ^ false ] ].
	"I use the dictionary avoid if (anti if campaign ;)"
	dict := {($( -> [ stk push: $( ]).
	($[ -> [ stk push: $[ ]).
	(${ -> [ stk push: ${ ]).
	($) -> [ myBlock value: $( ]).
	($] -> [ myBlock value: $[ ]).
	($} -> [ myBlock value: ${ ])} asDictionary.
	aString asArray do: [ :c | (dict at: c ifAbsent: [  ]) value ].
	"At the end of the day, if the stack is empty ^true"
	^ stk isEmpty
]
