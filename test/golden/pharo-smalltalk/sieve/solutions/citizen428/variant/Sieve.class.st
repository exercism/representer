Class {
	#name : #Sieve,
	#superclass : #Object,
	#category : #'Exercise@Sieve'
}

{ #category : #private }
Sieve >> multipliesOf: n below: limit [

	| increment |
	"For numbers > 2 all multiples of 2 have already been removed."
	increment := n = 2
		             ifTrue: [ 2 ]
		             ifFalse: [ n * 3 ].
	^ n * n to: limit by: increment
]

{ #category : #filtering }
Sieve >> primesLimit: anInteger [

	| result |
	result := self resultArray: anInteger.
	2 to: anInteger sqrtFloor do: [ :n | 
		(result at: n) ifNotNil: [ 
			result atAll: (self multipliesOf: n below: anInteger) put: nil ] ].
	^ result select: #isNotNil
]

{ #category : #private }
Sieve >> resultArray: limit [

	^ (1 to: limit) asArray
		  at: 1 put: nil;
		  yourself
]
