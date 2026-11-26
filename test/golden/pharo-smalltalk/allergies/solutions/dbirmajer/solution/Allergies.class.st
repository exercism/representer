"
# Allergies

Given a person's allergy score, determine whether or not they're allergic to a given item, and their full list of allergies.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #Allergies,
	#superclass : #Object,
	#category : #'Exercise@Allergies'
}

{ #category : #action }
Allergies >> allergicToItem: aString forScore: anInteger [ 
	
	| dict block|

	dict := {  
	'eggs' -> 1.
	'peanuts' -> 2.
	'shellfish' -> 3.
	'strawberries' -> 4.
	'tomatoes' -> 5.
	'chocolate' -> 6.
	'pollen' -> 7.
	'cats' -> 8.
	} asDictionary.
	
	block := [:s :n |  s size >= n and: [ ( s at: n ) = $1 ] ].
	
	^ dict at: aString  ifPresent: [ :n | block value: ( anInteger printStringBase: 2  ) reverse value: n  ]  ifAbsent:  [ false ]
]

{ #category : #action }
Allergies >> allergyListForScore: anInteger [ 
	| allergies |
	allergies := #('eggs' 'peanuts' 'shellfish' 'strawberries' 'tomatoes' 'chocolate' 'pollen' 'cats').
	^ allergies select: [ :x | self allergicToItem: x forScore: anInteger  ]
]
