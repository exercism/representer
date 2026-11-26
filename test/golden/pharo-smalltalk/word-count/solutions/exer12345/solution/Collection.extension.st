Extension { #name : #Collection }

{ #category : '*Exercise@WordCount' }
Collection >> histogram [
	"Create a dictionary from a sequence where each entry is a key and the number ot times that entry occurs is the value."

	" 28 primeFactors histogram >> a Dictionary(2->2 7->1 )"

	| dict setOfInputSequence |
	dict := Dictionary new.
	setOfInputSequence := self asSet.

	setOfInputSequence do: [ :eachOfSeq |
		dict
			at: eachOfSeq
			put:
			(self count: [ :each | (Set with: eachOfSeq) includes: each ]) ].
	^ dict
]
