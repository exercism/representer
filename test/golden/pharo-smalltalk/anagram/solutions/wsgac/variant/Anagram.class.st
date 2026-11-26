Class {
	#name : #Anagram,
	#superclass : #Object,
	#category : #'Exercise@Anagram'
}

{ #category : #action }
Anagram >> findAnagramsCandidates: aCollection subject: aString [

	| w h |
	w := aString asLowercase.
	h := self getHistogram: w.
	^ aCollection select: [ :cand | 
		  cand asLowercase ~= w & h = (self getHistogram: cand) ]
]

{ #category : #'as yet unclassified' }
Anagram >> getHistogram: word [

	| d |
	d := Dictionary new.
	word do: [ :char | 
		char isLetter ifTrue: [ 
			d at: char asLowercase update: [ :x | x + 1 ] initial: 2 ] ].
	^ d
]
