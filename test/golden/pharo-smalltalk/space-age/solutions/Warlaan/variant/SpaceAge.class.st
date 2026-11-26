Class {
	#name : #SpaceAge,
	#superclass : #Object,
	#instVars : [
		'yearLength'
	],
	#category : #'Exercise@SpaceAge'
}

{ #category : #'as yet unclassified' }
SpaceAge >> ageOnPlanet: planetName at: seconds [
	^ (seconds / 31557600) / (yearLength at: planetName)
]

{ #category : #initialization }
SpaceAge >> initialize [
	yearLength := Dictionary new
						at: 'Earth' put: 1;
						at: 'Mercury' put: 0.2408467;
						at: 'Venus' put: 0.61519726;
						at: 'Mars' put: 2.8808158;
						at: 'Jupiter' put: 11.862615;
						at: 'Saturn' put: 29.447498;
						at: 'Uranus' put: 84.016846;
						at: 'Neptune' put: 164.79132;
						yourself.

]
