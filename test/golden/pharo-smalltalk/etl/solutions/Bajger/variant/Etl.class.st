Class {
	#name : #Etl,
	#superclass : #Object,
	#category : #'Exercjse@Etl'
}

{ #category : #converting }
Etl >> transformData: pointToCharsDictionary [
	| charToPointDictionary |
	charToPointDictionary := Dictionary new.
	pointToCharsDictionary
		keysAndValuesDo: [ :pointValue :charArray | 
			charArray
				do: [ :aChar | 
					charToPointDictionary
						at: aChar asLowercase
						ifAbsentPut: pointValue asNumber ] ].
	^ charToPointDictionary
]
