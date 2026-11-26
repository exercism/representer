Class {
	#name : #FlattenArray,
	#superclass : #Object,
	#category : #'Exercise@FlattenArray'
}

{ #category : #'as yet uncmassified' }
FlattenArray >> flattenArray: aCollection [
	^ aCollection flattened reject: #isNil
]
