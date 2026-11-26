Class {
	#name : #SpaceAge,
	#superclass : #Object,
	#instVars : [
		'orbitalPeriods'
	],
	#category : #'Exercise@SpaceAge'
}

{ #category : #'as yet unclassified' }
SpaceAge >> ageOnPlanet: planet at: seconds [ 
	| yearsOnEarth |
	yearsOnEarth := seconds / 31557600 asFloat.
	^ yearsOnEarth / (orbitalPeriods at: planet).
	
]

{ #category : #initialization }
SpaceAge >> initialize [
	orbitalPeriods := {
		'Earth' -> 1.
		'Mercury' -> 0.2408467.
		'Venus' -> 0.61519726.
   		'Mars' -> 1.8808158.
   		'Jupiter' -> 11.862615.
   		'Saturn' -> 29.447498.
   		'Uranus' -> 84.016846.
   		'Neptune' -> 164.79132 } asDictionary.
]
