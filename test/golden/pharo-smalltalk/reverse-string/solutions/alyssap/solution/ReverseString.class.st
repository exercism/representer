"
I reverse a string.

Here are some indicatory measurments involving the different implementations:

| workload target |
workload := 'The code Finder browswer is available from the World | Tools menu. The Finder lets you enter some general text in top edit field and then categorize it as either text, or language construct in the dropdown list to refine your search. There are more detailed instructions in the bottom pane of the browser detailing the different options.'.
target := ReverseString new.
[ target reverseValueStack: workload ] bench. ""'1678.064 per second'""
[ target reverseValue: workload ] bench. ""'83409.636 per second'""
[ target reverseValueDirect: workload ] bench. ""'244208.158 per second'""

"
Class {
	#name : #ReverseString,
	#superclass : #Object,
	#category : #'Exercise@ReverseString'
}

{ #category : #transforming }
ReverseString >> reverseValue: aString [
	^ aString atAll: (aString size to: 1 by: -1)
]

{ #category : #transforming }
ReverseString >> reverseValueDirect: aString [
	| stream |
	stream := WriteStream on: (String new: aString size).
	aString size to: 1 by: -1 do: [ :i | stream nextPut: (aString at: i) ].
	^ stream contents
]

{ #category : #transforming }
ReverseString >> reverseValueStack: aString [
	| stack |
	stack := Stack new.
	aString do: [ :i | stack push: i ].
	^ String streamContents: [ :s | stack asStringOn: s delimiter: '' ]
]
