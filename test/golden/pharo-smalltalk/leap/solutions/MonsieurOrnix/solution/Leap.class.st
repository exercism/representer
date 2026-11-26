Class {
	#name : #Leap,
	#superclass : #Object,
	#category : #'Exercise@Leap'
}

{ #category : #'as yet unclassified' }
Leap >> leapYear: aYear [
	"Calculate if aYear is a leap year."
			
	(aYear isDivisibleBy: 400)
		ifTrue: [ ^true ]
		ifFalse: [ (aYear isDivisibleBy: 100) 
						ifTrue: [ ^false ]
						ifFalse: [ ^aYear isDivisibleBy: 4 ] ]
]
