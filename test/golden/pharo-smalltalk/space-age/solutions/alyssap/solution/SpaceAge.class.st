"
I tell you how old you would be on a given planet.
"
Class {
	#name : #SpaceAge,
	#superclass : #Object,
	#instVars : [
		'factors'
	],
	#category : #'Exercise@SpaceAge'
}

{ #category : #calculating }
SpaceAge >> ageOnPlanet: aString at: anInteger [ 
	^ anInteger / (factors at: aString asLowercase)
]

{ #category : #initialization }
SpaceAge >> initialize [
	| earth |
	earth := 31557600.
	factors := Dictionary new.
	factors
		at: 'earth' put: 31557600;
		at: 'mercury' put: 0.2408467 * earth;
		at: 'venus' put: 0.61519726 * earth;
		at: 'mars' put: 1.8808158 * earth;
		at: 'jupiter' put: 11.862615 * earth;
		at: 'saturn' put: 29.447498 * earth;
		at: 'uranus' put: 84.016846 * earth;
		at: 'neptune' put: 164.79132 * earth
]
