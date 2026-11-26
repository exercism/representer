"
I'm able to sing a subset the verses of 'The Twelve Days of Christmas'.
"
Class {
	#name : #TwelveDays,
	#superclass : #Object,
	#classVars : [
		'days',
		'verses'
	],
	#category : #'Exercise@TwelveDays'
}

{ #category : #operations }
TwelveDays >> allVersesFrom: anInteger [
	"Answer a string with all the verses from the i-th down to the first"

	| head result joiner |
	head := ', '
		join: ((anInteger to: 2 by: -1) collect: [ :v | verses at: v ]).
	joiner := (anInteger > 1
		ifTrue: [ ', and ' ]
		ifFalse: [ '' ]).
	result := joiner
		join:
			{head.
			(verses at: 1)}.
	^ result , '.'
]

{ #category : #initialization }
TwelveDays >> initialize [
	verses
		ifNil:
			[ verses := #('a Partridge in a Pear Tree' 'two Turtle Doves' 'three French Hens' 'four Calling Birds' 'five Gold Rings' 'six Geese-a-Laying' 'seven Swans-a-Swimming' 'eight Maids-a-Milking' 'nine Ladies Dancing' 'ten Lords-a-Leaping' 'eleven Pipers Piping' 'twelve Drummers Drumming').
			days := verses collect: [ :v | ((v findTokens: ' ') at: 1) , 'th' ].
			days at: 1 put: 'first'.
			days at: 2 put: 'second'.
			days at: 3 put: 'third'.
			days at: 4 put: 'fourth'.
			days at: 5 put: 'fifth'.
			days at: 8 put: 'eighth'.
			days at: 9 put: 'ninth'.
			days at: 12 put: 'twelfth' ]
]

{ #category : #operations }
TwelveDays >> reciteStartVerse: startInteger endVerse: endInteger [
	^ (startInteger to: endInteger)
		collect: [ :i | 
			'On the ' , (days at: i)
				, ' day of Christmas my true love gave to me: '
				, (self allVersesFrom: i) ]
]
