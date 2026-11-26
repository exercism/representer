Class {
	#name : #Etl,
	#superclass : #Object,
	#category : #'Exercjse@Etl'
}

{ #category : #accessing }
Etl >> transformData: aCollection [
	| result |
	result := Dictionary new.
	aCollection
		associationsDo: [ :pair | 
			pair value
				do: [ :value | result at: value asString asLowercase put: pair key asInteger ] ].
	^ result
]
