Class {
	#name : #ReverseString,
	#superclass : #Object,
	#category : #'Exercise@ReverseString'
}

{ #category : #actions }
ReverseString >> reverseValue: aString [
	"this is just copy&paste of #reverseDo: method"
	^ String
		streamContents:
			[ :aStream | aString size to: 1 by: -1 do: [ :index | aStream nextPut: (aString at: index) ] ]
]
