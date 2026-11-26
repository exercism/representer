"
I am a die. I know how many faces I have, and can be rolled to return an integer from 1 to my number of faces.

## Class API

- `withFaces:` a new die with a number of faces.

## Instance API

- `roll` rolls the die, returning an integer.

- `faces` how many faces the die has.

- `faces:` changes the number of faces the die has.
"
Class {
	#name : #Die,
	#superclass : #Object,
	#instVars : [
		'faces'
	],
	#category : #'Exercise@Die'
}

{ #category : #initialization }
Die class >> withFaces: anInteger [ 
	^ self new faces: anInteger.
]

{ #category : #accessing }
Die >> faces [
	
	^ faces.
]

{ #category : #initialization }
Die >> faces: anInteger [
	
	faces := anInteger.
]

{ #category : #initialization }
Die >> initialize [
	
	faces := 6.
]

{ #category : #operating }
Die >> roll [
	^ (1 to: faces) atRandom 
]
