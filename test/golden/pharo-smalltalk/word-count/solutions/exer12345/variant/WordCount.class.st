Class {
	#name : 'WordCount',
	#superclass : 'Object',
	#category : 'Exercise@WordCount',
	#package : 'Exercise@WordCount'
}

{ #category : 'exerdism' }
WordCount >> countWordsSentence: aString [

	| theDict workingString |
	theDict := Dictionary new.
	workingString := (aString asLowercase
		                  regex: '[[:alnum:]'']+'
		                  matchesCollect: [ :m | m ]) collect: [ :str |
		                 str trimBoth: [ :e | e = $' ] ].
	^ workingString histogram
]
