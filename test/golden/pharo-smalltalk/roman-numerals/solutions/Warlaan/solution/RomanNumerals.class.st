Class {
	#name : #RomanNumerals,
	#superclass : #Object,
	#category : #'Exercise@RomanNumerals'
}

{ #category : #accessing }
RomanNumerals >> createThousands: anInteger [
	^String streamContents: [ :stream | anInteger // 1000 timesRepeat: [ stream << 'M' ] ]

]

{ #category : #accessing }
RomanNumerals >> handleDigit: anInteger withOne: one andFive: five andTen: ten [
	anInteger = 4
		ifTrue: [ ^ one , five ].
	anInteger = 9
		ifTrue: [ ^ one , ten ].
	anInteger > 4
		ifTrue: [ ^ five , (self handleDigit: anInteger - 5 withOne: one andFive: five andTen: ten) ].
	^ String
		streamContents: [ :stream | anInteger timesRepeat: [ stream << one ] ]
]

{ #category : #accessing }
RomanNumerals >> romanNumber: anInteger [
	^ (self createThousands: anInteger),
	(self handleDigit: (anInteger digitAt: 3 base: 10) withOne: 'C' andFive: 'D' andTen: 'M'),
	(self handleDigit: (anInteger digitAt: 2 base: 10) withOne: 'X' andFive: 'L' andTen: 'C'),
	(self handleDigit: (anInteger digitAt: 1 base: 10) withOne: 'I' andFive: 'V' andTen: 'X')

]
