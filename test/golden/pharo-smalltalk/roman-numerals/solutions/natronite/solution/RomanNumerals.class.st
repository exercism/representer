Class {
	#name : #RomanNumerals,
	#superclass : #Object,
	#instVars : [
		'segments',
		'symbols'
	],
	#category : #'Exercise@RomanNumerals'
}

{ #category : #initialization }
RomanNumerals >> initialize [

	symbols := #( #( '' 'I' 'II' 'III' 'IV' 'V' 'VI' 'VII' 'VIII' 'IX' )
	              #( '' 'X' 'XX' 'XXX' 'XL' 'L' 'LX' 'LXX' 'LXXX' 'XC' )
	              #( '' 'C' 'CC' 'CCC' 'CD' 'D' 'DC' 'DCC' 'DCCC' 'CM' )
	              #( '' 'M' 'MM' 'MMM' ) )
]

{ #category : #'as yet unclassified' }
RomanNumerals >> romanNumber: aNumber [

	"A simpler solution with a 2D lookup array. "

	| writer digits |
	writer := WriteStream on: String new.
	digits := aNumber asString.
	digits withIndexDo: [ :c :i | 
		writer nextPutAll:
			((symbols at: digits size - i + 1) at: c digitValue + 1) ].
	^ writer contents
]
