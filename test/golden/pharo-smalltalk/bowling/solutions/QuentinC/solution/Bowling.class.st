Class {
	#name : #Bowling,
	#superclass : #Object,
	#instVars : [
		'frames',
		'frameIndex'
	],
	#category : #'Exercise@Bowling'
}

{ #category : #computing }
Bowling >> endGame [

	^ ((frameIndex > 10) and: ((frames select: [ :frame | frame needExtras ]) isEmpty))
]

{ #category : #computing }
Bowling >> initialize [

	super initialize.
	frames := OrderedCollection new.
	10 timesRepeat: [ frames add: BowlingFrame new ].
	frameIndex := 1
]

{ #category : #computing }
Bowling >> roll: anInteger [

	| currentFrame antePreviousFrame |
	self endGame ifTrue: [ self error: 'Cannot roll after game is over' ].
	frameIndex <= 10 ifTrue: [
		currentFrame := frames at: frameIndex.
		currentFrame add: anInteger ].
	frameIndex >= 2 ifTrue: [
		| previousFrame |
		previousFrame := frames at: frameIndex - 1.
		previousFrame needExtras ifTrue: [
			previousFrame addExtra: anInteger ] ].
	frameIndex >= 3 ifTrue: [
		antePreviousFrame := frames at: frameIndex - 2.
		antePreviousFrame needExtras ifTrue: [
			antePreviousFrame addExtra: anInteger ] ].
	currentFrame ifNotNil: [
		currentFrame endFrame ifTrue: [ frameIndex := frameIndex + 1 ] ]
]

{ #category : #scoring }
Bowling >> scoreAfterRolling: aCollection [

	aCollection do: [ :throw | self roll: throw ].
	((frameIndex < 10) or: ((frames select: [ :frame | frame needExtras ]) isNotEmpty )) ifTrue: [
		self error: 'Score cannot be taken until the end of the game' ].
	^ (frames collect: [ :frame | frame score ]) sum
]

{ #category : #computing }
Bowling >> scoreRolling: anInteger after: aCollection [

	| pinsCountExceededMessage scoreAfterRolling allRolls |
	pinsCountExceededMessage := 'Pin count exceeds pins on the lane'.

	anInteger < 0 ifTrue: [ self error: 'Negative roll is invalid' ].
	anInteger > 10 ifTrue: [ self error: pinsCountExceededMessage ].

	anInteger + (aCollection at: (1 max: aCollection size - 1)) > 10
		ifTrue: [ self error: pinsCountExceededMessage ].

	allRolls := aCollection asOrderedCollection.
	allRolls add: anInteger.
	scoreAfterRolling := self scoreAfterRolling: allRolls.
]
