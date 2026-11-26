Class {
	#name : #Allergies,
	#superclass : #Object,
	#category : #'Exercise@Allergies'
}

{ #category : #'as yet unclassified' }
Allergies >> allergicToItem:item forScore:score [

	|dictionary position binaryForm|
	position:=0.
	dictionary:=Dictionary  newFrom: { 'eggs' -> 0 "position 1". 'peanuts' -> 1 "position 2" . 'shellfish' -> 2 "position 4" . 'strawberries' -> 3 "position 8" . 'tomatoes' -> 4 "position 16" . 'chocolate' -> 5 "position 32" . 'pollen' -> 6 "position 64" . 'cats' ->7 "position 128"  }.
	position := dictionary at:item.
	binaryForm := score printStringBase: 2.
	binaryForm asString size < position 
		ifTrue: [ ^false ].
	(binaryForm asString size - position) < 1
		ifTrue: [ ^false ].
	((binaryForm asString at: (binaryForm asString size - position ) ) = $1)
		ifTrue: [ ^true ].
	^false.

]

{ #category : #'as yet unclassified' }
Allergies >> allergyListForScore:score [

	|binaryForm dictionary storage numberOfElements|
	dictionary:=Dictionary  newFrom: { 0 -> 'eggs' "position 1". 1 -> 'peanuts' "position 2" . 2 -> 'shellfish' "position 4" . 3 -> 'strawberries' "position 8" . 4 -> 'tomatoes' "position 16" . 5 -> 'chocolate' "position 32" . 6 -> 'pollen' "position 64" . 7 -> 'cats' "position 128"  }.
	binaryForm := (score printStringBase: 2) asString.
	numberOfElements := binaryForm size.
	binaryForm size > 8
		ifTrue: [ numberOfElements := 8 ].
	storage := OrderedCollection new .
	1 to: numberOfElements do: [ :i| (binaryForm at: (binaryForm size - i+1)) = $1 ifTrue: [ storage add: (dictionary  at: (i-1)) ] ].
	^storage asArray .
]
