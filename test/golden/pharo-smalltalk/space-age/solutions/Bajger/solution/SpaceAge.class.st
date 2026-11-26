Class {
	#name : #SpaceAge,
	#superclass : #Object,
	#instVars : [
		'planetOrbits'
	],
	#classInstVars : [
		'PlanetOrbits'
	],
	#category : #'Exercise@SpaceAge'
}

{ #category : #'private - constants' }
SpaceAge class >> earthSecondsPerYear [

	^ 365.25 days asSeconds
]

{ #category : #'private - constants' }
SpaceAge class >> getPlanetOrbits [
	PlanetOrbits isNil
		ifTrue: [ PlanetOrbits := {('Earth' -> 1).
			('Mercury' -> 0.2408467).
			('Venus' -> 0.61519726).
			('Mars' -> 1.8808158).
			('Jupiter' -> 11.862615).
			('Saturn' -> 29.447498).
			('Uranus' -> 84.016846).
			('Neptune' -> 164.79132)} asDictionary ].
	^ PlanetOrbits
]

{ #category : #accessing }
SpaceAge >> ageOnPlanet: planetString at: durationInSeconds [
	| orbitalDurationSeconds |
	"determine duration of planet's orbital period in seconds,
	 result is ratio between input seconds and planet's orbital duration in seconds.
	"
	orbitalDurationSeconds := self orbitalPeriodInEarthSecondsForPlanet: planetString.
	^ durationInSeconds / orbitalDurationSeconds
]

{ #category : #private }
SpaceAge >> orbitalPeriodInEarthSecondsForPlanet: aString [
	"gets planet's year period relative to earth and multiply by earth year seconds"
	| orbitalYrToEearth |
	orbitalYrToEearth := self class getPlanetOrbits
		at: aString
		ifAbsent: [ self error: ('Unknown planet: ', aString,', cannot determine orbital period.')].
	^ self class  earthSecondsPerYear * orbitalYrToEearth
]
