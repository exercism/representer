Class {
	#name : #Leap,
	#superclass : #Object,
	#category : #'Exercise@Leap'
}

{ #category : #'as yet unclassified' }
Leap >> leapYear: year [
	"checks if year is a leapyear"

	year % 4 == 0 ifTrue: [ 
		year % 100 == 0 ifTrue: [ 
			year % 400 == 0 ifTrue: [ ^ true ].
			^ false ].
		 ^ true]. 	
		^ false	
	
]
