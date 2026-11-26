Class {
	#name : #BowlingFrame,
	#superclass : #Object,
	#instVars : [
		'rolls',
		'endFrame',
		'extras'
	],
	#category : #'Exercise@Bowling'
}

{ #category : #adding }
BowlingFrame >> add: anInteger [

	rolls add: anInteger.
	(anInteger = 10 or: rolls size = 2) ifTrue: [ endFrame := true ]
]

{ #category : #adding }
BowlingFrame >> addExtra: anInteger [

	extras add: anInteger
]

{ #category : #adding }
BowlingFrame >> endFrame [

	^ endFrame
]

{ #category : #adding }
BowlingFrame >> initialize [

	super initialize.
	rolls := OrderedCollection new.
	endFrame := false.
	extras := OrderedCollection new.
]

{ #category : #adding }
BowlingFrame >> isSpare [
	
	rolls ifEmpty: [ ^ false ].
	^ rolls sum = 10
]

{ #category : #adding }
BowlingFrame >> isStrike [
	rolls ifEmpty: [ ^ false ].
	^ (rolls at: 1) = 10
]

{ #category : #adding }
BowlingFrame >> needExtras [

	^ (self isStrike and: extras size < 2) or:
		  (self isSpare and: extras size < 1)
]

{ #category : #adding }
BowlingFrame >> score [

	^ rolls sum + (self sumExtras)
]

{ #category : #adding }
BowlingFrame >> sumExtras [

	extras ifEmpty: [ ^ 0 ].
	^ extras sum
]
