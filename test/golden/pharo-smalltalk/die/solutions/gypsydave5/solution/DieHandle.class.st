"
I am a collection of dice. I know the dice I hold, and I can roll them all to return an integer.

## Class API

- `new` creates a new DieHandle.

## Instance API

- `addDie:` adds a die to my collection of dice.

- `diceNumber` how many dice I have.

- `do:` iterates over my dice.

- `roll` rolls all my dice.
"
Class {
	#name : #DieHandle,
	#superclass : #Object,
	#instVars : [
		'dice'
	],
	#category : #'Exercise@Die'
}

{ #category : #'as yet unclassified' }
DieHandle class >> ofCount: count withFace: faces [
	^ self new addCollection: ((1 to: count) asBag collect: [ :each |  Die withFaces: faces ])
]

{ #category : #adding }
DieHandle >> + aDieHandle [ 
	^ self class new addCollection: self; addCollection: aDieHandle  

]

{ #category : #adding }
DieHandle >> addCollection: aCollection [ 
	aCollection do: [ :each | self addDie: each ]
]

{ #category : #adding }
DieHandle >> addDie: aDie [
	dice add: aDie.
]

{ #category : #accessing }
DieHandle >> diceNumber [
	^ dice size.
]

{ #category : #iterating }
DieHandle >> do: aBlockClosure [ 
	dice do: aBlockClosure.
]

{ #category : #initialization }
DieHandle >> initialize [
	dice := Bag new.
]

{ #category : #operating }
DieHandle >> roll [
	^ (dice collect: #roll) sum.
]
