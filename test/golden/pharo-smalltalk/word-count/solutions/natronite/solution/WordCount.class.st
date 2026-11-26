Class {
	#name : #WordCount,
	#superclass : #Object,
	#category : #'Exercise@WordCount'
}

{ #category : #'as yet unclassified' }
WordCount >> countWordsSentence: aString [

	| splits grouped result |
	splits := (aString asLowercase splitOn: '[,\s]' asRegex)
		          collect: [ :word | 
		          word trimBoth: [ :c | (c isLetter or: c isDigit) not ] ]
		          thenSelect: [ :word | word isNotEmpty ].
	grouped := splits groupedBy: [ :word | 
		           splits count: [ :w | w = word ] ].

	result := Dictionary new.
	grouped associations do: [ :group | 
		group value do: [ :w | result at: w put: group key ] ].
	^ result
]
