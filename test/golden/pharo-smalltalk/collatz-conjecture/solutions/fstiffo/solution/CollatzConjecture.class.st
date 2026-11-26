Class {
	#name : 'CollatzConjecture',
	#superclass : 'Object',
	#category : 'Exercise@CollatzConjecture',
	#package : 'Exercise@CollatzConjecture'
}

{ #category : 'exercism' }
CollatzConjecture >> stepsFrom: anInteger [
	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	anInteger <= 0 ifTrue: [ self error: 'Only positive numbers are allowed' ].
	^ anInteger = 1
		  ifTrue: [ 0 ]
		  ifFalse: [
			  | next |
			  next := anInteger even
				          ifTrue: [ anInteger / 2 ]
				          ifFalse: [ anInteger * 3 + 1 ].
			  1 + (self stepsFrom: next) ]
]
