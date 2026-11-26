"
HULK SMASH. HULK FLATTEN ARRAY.
"
Class {
	#name : #FlattenArray,
	#superclass : #Object,
	#category : #'Exercise@FlattenArray'
}

{ #category : #'as yet unclassified' }
FlattenArray >> flattenArray: anArray [
	^ (self flattenArray: anArray into: OrderedCollection new ) asArray

]

{ #category : #'as yet unclassified' }
FlattenArray >> flattenArray: anArray into: aCollection [ 
	anArray do: [ :each |
		(each isKindOf: Collection)
			ifTrue: [ self flattenArray: each into: aCollection ]
			ifFalse: [ 
				each notNil ifTrue: [ aCollection add: each ]
			]
		].
	^ aCollection
]
