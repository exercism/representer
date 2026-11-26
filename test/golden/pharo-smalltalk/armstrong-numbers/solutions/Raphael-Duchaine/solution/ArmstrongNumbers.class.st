"
I check if a number is an Armstrong number

# Responsabilities
- I check if the each digit to the power of the decimalDigitLength is equal the original number

# Collaborators
- ArmstrongNumbersTest

## Of Core Libs
- Integer
- Number
"
Class {
	#name : #ArmstrongNumbers,
	#superclass : #Object,
	#category : #'Exercise@ArmstrongNumbers'
}

{ #category : #calculating }
ArmstrongNumbers class >> digitsRaisedToDigitLength: anInteger [

	^ (1 to: anInteger decimalDigitLength) collect: [ :index | 
		  (anInteger decimalDigitAt: index) ** anInteger decimalDigitLength ]
]

{ #category : #calculating }
ArmstrongNumbers class >> isArmstrongNumber: anInteger [

	^ anInteger == (self digitsRaisedToDigitLength: anInteger) sum
]

{ #category : #calculating }
ArmstrongNumbers >> isArmstrongNumber: anInteger [

	^ self class isArmstrongNumber: anInteger
]
