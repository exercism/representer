"
Exercism Armstrong Numbers
"
Class {
	#name : #ArmstrongNumbers,
	#superclass : #Object,
	#category : #'Exercise@ArmstrongNumbers'
}

{ #category : #'as yet unclassified' }
ArmstrongNumbers >> convertNumber: number toCol: col [
	"comment stating purpose of message"

	| |
	number < 10
	ifTrue:[
		col add: number. 
		^ col
	]
   ifFalse:[
		col add: (number rem: 10).
		^ self convertNumber: ((number / 10) floor) toCol: col
	]
]

{ #category : #testing }
ArmstrongNumbers >> isArmstrongNumber: numberToTest [
	"comment stating purpose of message"

	| col sum digitNb |
	col := self convertNumber: numberToTest toCol: OrderedCollection new.
	sum := 0.
	digitNb := col size.
	col do: [ :each | sum := sum + (each raisedTo: digitNb) ].
	^ sum = numberToTest 
	
]
