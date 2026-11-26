Class {
	#name : #ReverseString,
	#superclass : #Object,
	#category : #'Exercise@ReverseString'
}

{ #category : #'as yet unclassified' }
ReverseString >> reverseValue: anString [	
"comment stating purpose of message"
| y w |
y := anString size.
w := WriteStream on: (String new: y).
y to:1  by: -1 do:[:x| w nextPut: (anString at: x)].
^ w contents.
	
	
]
