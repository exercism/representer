"
Im an string reverser.


"
Class {
	#name : #ReverseString,
	#superclass : #Object,
	#category : #'Exercise@ReverseString'
}

{ #category : #actions }
ReverseString >> reverseValue: aString [ 
  "Using stream to store the characters"

  |list length|
	list :=  WriteStream on: String new.
	length := (aString  size).
	(length  to: 1 by:-1) do: 
		[ :n | list nextPut:(aString at: n) ].

   ^ list  contents
]
