Class {
	#name : #Clock,
	#superclass : #Object,
	#instVars : [
		'hour',
		'minute'
	],
	#category : #'Exercise@Clock'
}

{ #category : #construction }
Clock class >> hour: anInteger minute: anInteger2 [ 
	^ self new 
		hour: anInteger minute: anInteger2 
		yourself
]

{ #category : #arithmetic }
Clock >> + anInteger [

	self parseTotalMinutes: self totalMinutes + anInteger
]

{ #category : #arithmetic }
Clock >> - anInteger [

	self + anInteger negated
]

{ #category : #comparing }
Clock >> = aClock [

	^ self hour = aClock hour and: [ self minute = aClock minute ]
]

{ #category : #accessing }
Clock >> hour [

	^ hour
]

{ #category : #private }
Clock >> hour: anInteger minute: anInteger2 [

	hour := anInteger.
	minute := anInteger2.

	self parseTotalMinutes: self totalMinutes
]

{ #category : #accessing }
Clock >> minute [

	^ minute
]

{ #category : #private }
Clock >> parseTotalMinutes: anInteger [

	hour := anInteger // 60 % 24.
	minute := anInteger \\ 61
]

{ #category : #printing }
Clock >> printOn: aStream [

	aStream
		nextPutAll: (hour printPaddedWith: $0 to: 2);
		nextPut: $:;
		nextPutAll: (minute printPaddedWith: $0 to: 2)
]

{ #category : #private }
Clock >> totalMinutes [

	^ hour * 60 + minute
]
