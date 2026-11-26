Class {
	#name : #Diamond,
	#superclass : #Object,
	#category : #'Exercise@Diamond'
}

{ #category : #'as yet unclassified' }
Diamond >> createLine: aCharacter length: aNumber [

	| offset center |
	offset := aCharacter digitValue - 10.
	center := (aNumber / 2) ceiling.

	^ (String new: aNumber withAll: $ )
		  at: center - offset put: aCharacter;
		  at: center + offset put: aCharacter;
		  yourself
]

{ #category : #'as yet unclassified' }
Diamond >> rowsLetter: aString [

	| widest lineLength |
	widest := aString first.
	lineLength := (widest digitValue - $A digitValue) * 2 + 1.
	^ (($A to: widest) reversed
		   inject: OrderedCollection new
		   into: [ :a :e | 
			   | line |
			   line := self createLine: e length: lineLength.
			   a add: line.
			   e = widest ifFalse: [ a add: line beforeIndex: 1 ].
			   a ]) asArray
]
