"
A simple solution
"
Class {
	#name : #Leap,
	#superclass : #Object,
	#category : #'Exercise@Leap'
}

{ #category : #helper }
Leap >> is: anInteger evenlyDivisibleBy: divisorInteger [
	^(anInteger \\ divisorInteger) = 0
]

{ #category : #exercism }
Leap >> leapYear: anInteger [
	^ (self is: anInteger evenlyDivisibleBy: 4)
		and: [ (self is: anInteger evenlyDivisibleBy: 400)
				or: [ (self is: anInteger evenlyDivisibleBy: 100) not ] ]
]
