Class {
	#name : #Allergies,
	#superclass : #Object,
	#classInstVars : [
		'AllergiesList'
	],
	#category : #'Exercise@Allergies'
}

{ #category : #'private-constants' }
Allergies class >> getAllergiesList [

	AllergiesList ifNil: [ AllergiesList := #('eggs' 'peanuts' 'shellfish' 'strawberries' 'tomatoes' 'chocolate' 'pollen' 'cats')].
	^ AllergiesList 
]

{ #category : #conversion }
Allergies >> allergicToItem: allergyString forScore: aScore [ 
	^ (self allergyListForScore: aScore) includes: allergyString
]

{ #category : #conversion }
Allergies >> allergyListForScore: aScore [
	^ self class getAllergiesList
		withIndexSelect: [ :each :index | 
			| powerOfTwo |
			powerOfTwo := 2 raisedTo: index - 1.
			(powerOfTwo bitAt: index) = (aScore bitAt: index) ]
]
