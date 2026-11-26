Class {
	#name : #Sieve,
	#superclass : #Object,
	#category : #'Exercise@Sieve'
}

{ #category : #exercism }
Sieve >> primesLimit: limit [
	| array |
	array := Array new: limit withAll: true.
	^ Array streamContents: [ :stream | 
		  2 to: limit do: [ :i | 
			  (array at: i) ifTrue: [
				  stream nextPut: i.
				  i + i to: limit by: i do: [ :j | array at: j put: false ]]]]
]
