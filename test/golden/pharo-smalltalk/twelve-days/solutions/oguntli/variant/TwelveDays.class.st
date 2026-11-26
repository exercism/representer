Class {
	#name : #TwelveDays,
	#superclass : #Object,
	#category : #'Exercise@TwelveDays'
}

{ #category : #'as yet unclassified' }
TwelveDays >> combineVerses: fromDay [
 	| a b |
	fromDay > 1 ifTrue: [ 
			a := (fromDay to: 2 by: -1) collect: [ :e | self verses at: e].
			b := ', ' join: a allButLast.
			^b, ', and ', a last, '.']
					ifFalse: [ 
						^(self verses at: fromDay), '.'
						 ]

]

{ #category : #'as yet unclassified' }
TwelveDays >> days [
	^ #('first' 'second' 'third' 'fourth' 'fifth' 'sixth' 'seventh' 'eighth' 'ninth' 'tenth' 'eleventh' 'twelfth')
]

{ #category : #'as yet unclassified' }
TwelveDays >> reciteStartVerse: startAt endVerse: endAt [
	| v |
	v := (startAt to: endAt) collect: [ :e | 
		'On the ', (self days at: e), ' day of Christmas my true love gave to me: ', 
		(self combineVerses: e)].
	Transcript show: v.
	^v

]

{ #category : #'as yet unclassified' }
TwelveDays >> verses [
	^ #( 'a Partridge in a Pear Tree' 'two Turtle Doves' 'three French Hens' 'four Calling Birds' 'five Gold Rings' 'six Geese-a-Laying' 'seven Swans-a-Swimming' 'eight Maids-a-Milking' 'nine Ladies Dancing' 'ten Lords-a-Leaping' 'eleven Pipers Piping' 'twelve Drummers Drumming' )


]
