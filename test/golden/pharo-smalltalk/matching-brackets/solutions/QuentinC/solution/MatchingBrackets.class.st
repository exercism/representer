Class {
	#name : #MatchingBrackets,
	#superclass : #Object,
	#instVars : [
		'brackets'
	],
	#category : #'Exercise@MatchingBrackets'
}

{ #category : #testing }
MatchingBrackets >> initialize [

	super initialize.
	brackets := {
		            ($} -> ${).
		            ($) -> $().
		            ($] -> $[) } asDictionary
]

{ #category : #testing }
MatchingBrackets >> isPaired: aString [

	| stack |
	stack := Stack new.
	aString do: [ :char |
		| lastBracket |
		(brackets values anySatisfy: [ :c | c = char ])
			ifTrue: [ stack push: char ]
			ifFalse: [
				(brackets keys anySatisfy: [ :c | c = char ]) ifTrue: [
					stack ifEmpty: [ ^ false ].
					lastBracket := stack pop.
					(brackets at: char) = lastBracket ifFalse: [ ^ false ] ] ] ].
	^ stack isEmpty
]
