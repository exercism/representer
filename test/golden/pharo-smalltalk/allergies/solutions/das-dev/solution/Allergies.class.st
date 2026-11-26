Class {
	#name : #Allergies,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #'Exercise@Allergies'
}

{ #category : #public }
Allergies >> allergicToItem: item forScore: score [
	^ (self allergyListForScore: score) 
		includes: item
]

{ #category : #public }
Allergies >> allergyListForScore: score [
	^ items withIndexSelect: [ :e :i | 
		0 ~= (2 ** (i - 1) & score) ]
]

{ #category : #initialization }
Allergies >> initialize [
	super initialize.
	items := (Array new: 8)
		at: 1 put: 'eggs';
		at: 2 put: 'peanuts';
		at: 3 put: 'shellfish';
		at: 4 put: 'strawberries';
		at: 5 put: 'tomatoes';
		at: 6 put: 'chocolate';
		at: 7 put: 'pollen';
		at: 8 put: 'cats';
		yourself.
]
