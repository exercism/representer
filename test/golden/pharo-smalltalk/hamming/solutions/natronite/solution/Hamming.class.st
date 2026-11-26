Class {
	#name : #Hamming,
	#superclass : #Object,
	#category : #'Exercise@Hamming'
}

{ #category : #'as yet unclassified' }
Hamming >> distanceStrand1: leftStrand strand2: rightStrand [

	self validateStrand1: leftStrand strand2: rightStrand.
	^ (leftStrand withIndexSelect: [ :e :i | e ~= (rightStrand at: i) ])
		  size
]

{ #category : #'as yet unclassified' }
Hamming >> validateStrand1: leftStrand strand2: rightStrand [

	leftStrand size = rightStrand size ifTrue: [ ^ self ].
	leftStrand ifEmpty:  [ self error: 'left strand must not be empty' ]. 
	rightStrand ifEmpty:  [ self error: 'right strand must not be empty' ]. 
	self error: 'left and right strands must be of equal length'
]
