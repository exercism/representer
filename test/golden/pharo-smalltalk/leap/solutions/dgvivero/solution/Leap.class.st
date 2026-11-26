Class {
	#name : #Leap,
	#superclass : #Object,
	#category : #'Exercise@Leap'
}

{ #category : #accesing }
Leap >> leapYear: aYear [
	"on every year that is evenly divisible by 4
  		except every year that is evenly divisible by 100
    		unless the year is also evenly divisible by 400"
	^(aYear \\\ 4 == 0) & ((aYear \\\ 100 ~= 0) | (aYear \\\ 400 == 0))
		
]
