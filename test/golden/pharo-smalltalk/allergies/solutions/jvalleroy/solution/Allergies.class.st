Class {
	#name : #Allergies,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #'Exercise@Allergies'
}

{ #category : #checking }
Allergies >> allergicToItem: item forScore: score [

	| index |
	index := self items indexOf: item.
	^ (score bitAt: index) = 1
]

{ #category : #reporting }
Allergies >> allergyListForScore: score [ 
	^ self items withIndexSelect: [ :value :index | (score bitAt: index) = 1 ]
]

{ #category : #accessing }
Allergies >> items [

	^ #( 'eggs' 'peanuts' 'shellfish' 'strawberries' 'tomatoes'
	     'chocolate' 'pollen' 'cats' )
]
