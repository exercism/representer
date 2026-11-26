"
I'm able to convert Roman numerals (between 1 and 3999)
"
Class {
	#name : #RomanNumerals,
	#superclass : #Object,
	#classVars : [
		'RomanDigits'
	],
	#category : #'Exercise@RomanNumerals'
}

{ #category : #'class initialization' }
RomanNumerals class >> initialize [
	RomanDigits := OrderedDictionary 
		newFrom:
			{(1 -> 'I').
			(5 -> 'V').
			(10 -> 'X').
			(50 -> 'L').
			(100 -> 'C').
			(500 -> 'D').
			(1000 -> 'M')}
]

{ #category : #converting }
RomanNumerals >> roman: anInteger at: position [
	"position is 1 10 100 1000, meaning units, tenth, hundreds, thousands"

	| result stdDigit middleDigit nextDigit |
	stdDigit := RomanDigits at: position.
	middleDigit := RomanDigits at: 5 * position ifAbsent: [''].
	nextDigit := RomanDigits at: 10 * position ifAbsent: [''].
	result := WriteStream on: String new.
	anInteger < 4
		ifTrue: [ 1 to: anInteger do: [ :i | result nextPutAll: stdDigit ] ].
	anInteger = 4
		ifTrue: [ ^ stdDigit , middleDigit ].
	anInteger = 9
		ifTrue: [ ^ stdDigit , nextDigit ].
	anInteger > 4
		ifTrue: [ result nextPutAll: middleDigit.
			6 to: anInteger do: [ :i | result nextPutAll: stdDigit ] ].
	^ result contents
]

{ #category : #converting }
RomanNumerals >> romanNumber: anInteger [
	| roman |
	roman := WriteStream on: String new.
	#(1000 100 10 1)
		do: [ :weight | 
			| digit |
			digit := anInteger // weight % 10.
			digit > 0
				ifTrue: [ roman nextPutAll: (self roman: digit at: weight) ] ].
	^ roman contents
]
