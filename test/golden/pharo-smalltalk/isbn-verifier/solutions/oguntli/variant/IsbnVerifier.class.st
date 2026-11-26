Class {
	#name : #IsbnVerifier,
	#superclass : #Object,
	#instVars : [
		'multiplier'
	],
	#category : #'Exercise@IsbnVerifier'
}

{ #category : #'as yet unclassified' }
IsbnVerifier >> initialize [
	multiplier := (10 to: 1 by: -1) collect: [ :e | e ] 
]

{ #category : #testing }
IsbnVerifier >> isValidIsbn: aString [ 
	| digits sum  |
	aString isEmptyOrNil ifTrue: [ ^false ].
	sum := 0.
	digits := (aString asOrderedCollection select: [ :e | e isDigit ]) collect: [ :d | d digitValue ].
	aString last = $X ifTrue: [ digits addLast: 10] .
	digits size ~= 10 ifTrue: [^false] .
	1 to: 10 do: [ :e | sum := sum + ((12 - e) * (digits at: e)) ].
	^ sum \\ 11 = 0.
	

]
