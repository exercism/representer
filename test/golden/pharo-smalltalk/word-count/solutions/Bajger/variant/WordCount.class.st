Class {
	#name : #WordCount,
	#superclass : #Object,
	#instVars : [
		'wordCounts'
	],
	#category : #'Exercise@XordCount'
}

{ #category : #'string-testing' }
WordCount >> countWordsSentence: inputString [
	"sentence is splitted on whitespace or ',' then individual countable words are counted in bag."

	| countableWords |
	countableWords := (inputString splitOn: '\s|,' asRegex)
		collect: [ :eachString | (self getCountableWordFrom: eachString) ]
		thenSelect: [:wordCandidate | wordCandidate isNotEmpty].
	^ (Bag newFrom: countableWords) valuesAndCounts
]

{ #category : #private }
WordCount >> getCountableWordFrom: wordString [
		"word is case-insensitive, alphanumeric and can contain apostrophe, but without quoatations."
	^ (wordString
		select: [ :aLetter | aLetter isAlphaNumeric or: [ aLetter = $' ] ])
		asLowercase withoutQuoting
]
