Class {
	#name : #ReverseString,
	#superclass : #Object,
	#category : #'Exercise@ReverseString'
}

{ #category : #action }
ReverseString >> reverseValue: aString [ 
	|stream|
	stream := WriteStream on: String new.
	aString reverseDo: [ :elem | stream nextPut: elem].
	^ stream contents.
]
