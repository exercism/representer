"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I am a translator, to translate orbital period between plantes in the solar system.

For the Responsibility part: My responsibility is to translate a timeInterval given in seconds on a planet to Earth Years

- ageOnPlanet: aPlanetName at: anInteger
"
Class {
	#name : #SpaceAge,
	#superclass : #Object,
	#instVars : [
		'orbitalPeriods'
	],
	#category : #'Exercise@SpaceAge'
}

{ #category : #'as yet unclassified' }
SpaceAge >> ageOnPlanet: aPlanetName at: anInteger [
	"Return time anInteger on planet aPlanetName in years"
	|orbitalPeriod earthYears|
	orbitalPeriod := orbitalPeriods at: aPlanetName.
	earthYears := anInteger / 60 / 60 / 24 / 365.25.
	^ earthYears / orbitalPeriod.
]

{ #category : #initialization }
SpaceAge >> initialize [
	"Initialize orbitalPeriods"

	orbitalPeriods := {('Earth' -> 1).
	('Mercury' -> 0.2408467).
	('Venus' -> 0.61519726).
	('Mars' -> 1.8808158).
	('Jupiter' -> 11.862615).
	('Saturn' -> 29.447498).
	('Uranus' -> 84.016846).
	('Neptune' -> 164.79132)} asDictionary
]
