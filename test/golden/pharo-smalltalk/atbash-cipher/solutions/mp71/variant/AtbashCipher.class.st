Class {
	#name : #AtbashCipher,
	#superclass : #Object,
	#instVars : [
		'key'
	],
	#category : #'Exercise@AtbashCipher'
}

{ #category : #'as yet unclassified' }
AtbashCipher >> decodePhrase: aPhrase [
	^ String
		streamContents: [ :stream | 
			((aPhrase asArray select: [ :c | c isAlphaNumeric ])
				collect: [ :c | 
					c < $a
						ifTrue: [ c ]
						ifFalse: [ key at: c asciiValue - $a asciiValue + 1 ] ])
				do: [ :c | stream nextPut: c ] ]
]

{ #category : #'as yet unclassified' }
AtbashCipher >> encodePhrase: aPhrase [
	^ String
		streamContents: [ :stream | 
			(((aPhrase asLowercase asArray select: [ :c | c isAlphaNumeric ])
				collect: [ :c | 
					c < $a
						ifTrue: [ c asciiValue ]
						ifFalse: [ c asciiValue - $a asciiValue + 1 ] ])
				collect: [ :v | 
					v < 28
						ifTrue: [ key at: v ]
						ifFalse: [ Character value: v ] ])
				doWithIndex: [ :c :i | 
					((i - 1) \\ 5 = 0 and: [ i ~= 1 ])
						ifTrue: [ stream nextPut: Character space ].
					stream nextPut: c ] ]
]

{ #category : #initialization }
AtbashCipher >> initialize [ 
  key := 'abcdefghijklmnopqrstuvwxyz' reverse.
]
