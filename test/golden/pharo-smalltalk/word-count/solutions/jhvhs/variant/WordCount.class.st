"
Implementation
"
Class {
	#name : #WordCount,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : #'Exercise@WordCount'
}

{ #category : #implementation }
WordCount >> countWordsSentence: aString [

string := aString asLowercase .
	^ self
		  stripQuotes;
		  stripSymbols;
		  getWordFequency
]

{ #category : #private }
WordCount >> getWordFequency [

	^string substrings inject: Dictionary new into:  [ :dict :word | 
		dict at: word update: [ :old | old + 1 ] initial: 2. dict ]
]

{ #category : #private }
WordCount >> passThroughCharaters [
 ^ Character alphabet , Character separators , '''0123456789'.
]

{ #category : #private }
WordCount >> stripQuotes [

	string := String streamContents: [ :writeStream | 
		          self stripQuotesIntoStream: writeStream ]
]

{ #category : #private }
WordCount >> stripQuotesFromStream: readStream intoStream: writeStream [
writeStream nextPutAll: (readStream upTo: $').
		(('rst' includes: readStream peek) and:
			 (Character alphabet includes: writeStream peekLast)) ifTrue: [ 
			writeStream nextPut: $' ]
]

{ #category : #private }
WordCount >> stripQuotesIntoStream: writeStream [

	| readStream |
	readStream := string readStream.
	[ readStream atEnd ] whileFalse: [ self stripQuotesFromStream: readStream  intoStream: writeStream   ]
]

{ #category : #private }
WordCount >> stripSymbols [

	string := String streamContents: [ :writeStream | 
		          self
			          stripSymbolsFromStream: string readStream
			          toStream: writeStream ]
]

{ #category : #private }
WordCount >> stripSymbolsFromStream: readStream toStream: writeStream [

	| ch |
	[ readStream atEnd ] whileFalse: [ 
		ch := readStream next.
		(self passThroughCharaters includes: ch)
			ifTrue: [ writeStream nextPut: ch ]
			ifFalse: [ ch = $, ifTrue: [ writeStream nextPut: Character space ] ] ]
]
