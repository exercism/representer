"
I can tell you if a year was a leap year or not.
"
Class {
	#name : #Leap,
	#superclass : #Object,
	#category : #'Exercise@Leap'
}

{ #category : #predicate }
Leap >> leapYear: aYear [
	^ aYear % 4 = 0 & (aYear % 100 ~= 0 | (aYear % 400 = 0))
]
