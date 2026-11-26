Class {
	#name : #Allergies,
	#superclass : #Object,
	#category : #'Exercise@Allergies'
}

{ #category : #querying }
Allergies >> allergenics [
	^ OrderedDictionary new
		at: 'eggs' put: 1;
		at: 'peanuts' put: 2;
		at: 'shellfish' put: 4;
		at: 'strawberries' put: 8;
		at: 'tomatoes' put: 16;
		at: 'chocolate' put: 32;
		at: 'pollen' put: 64;
		at: 'cats' put: 128;
		yourself.
]

{ #category : #querying }
Allergies >> allergicToItem: aString forScore: anInteger [ 
	^((self allergenics at: aString) bitAnd: anInteger) > 0.
]

{ #category : #querying }
Allergies >> allergyListForScore: anInteger [ 
	^(self allergenics keys) select: [ :key | self allergicToItem: key forScore: anInteger ].
]
