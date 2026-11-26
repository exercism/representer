Class {
	#name : #Frame,
	#superclass : #Object,
	#instVars : [
		'score',
		'rolls'
	],
	#category : #'Exercise@Bowling'
}

{ #category : #'instance creation' }
Frame class >> new: aNumber rolls: anArray [

	anArray ifEmpty: [ 
		self error: 'Score cannot be taken until the end of the game' ].

	anArray first = 10 ifTrue: [ ^ self strike: aNumber rolls: anArray ].
	anArray size < 2 ifTrue: [ 
		self error: 'Score cannot be taken until the end of the game' ].
	anArray first + anArray second = 10 ifTrue: [ 
		^ self spare: aNumber rolls: anArray ].
	anArray first + anArray second > 10 ifTrue: [ self error: 'Pin count exceeds pins on the lane' ].
	^ self open: aNumber rolls: anArray
]

{ #category : #private }
Frame class >> open: aNumber rolls: anArray [

	^ self new
		  score: anArray first + anArray second rolls: 2;
		  yourself
]

{ #category : #private }
Frame class >> spare: aNumber rolls: anArray [

	anArray size < 3 ifTrue: [ 
		self error: 'Score cannot be taken until the end of the game' ].

	aNumber = 10 ifTrue: [ 
		^ self new
			  score: anArray first + anArray second + anArray third rolls: 3;
			  yourself ].

	^ self new
		  score: anArray first + anArray second + anArray third rolls: 2;
		  yourself
]

{ #category : #private }
Frame class >> strike: aNumber rolls: anArray [

	anArray size < 3 ifTrue: [ 
		self error: 'Score cannot be taken until the end of the game' ].

	aNumber = 10 ifTrue: [ 
		(anArray second < 10 and: anArray second + anArray third > 10) 
			ifTrue: [ self error: 'Pin count exceeds pins on the lane' ].
		^ self new
			  score: anArray first + anArray second + anArray third rolls: 3;
			  yourself ].

	^ self new
		  score: anArray first + anArray second + anArray third rolls: 1;
		  yourself
]

{ #category : #scoring }
Frame >> rolls [

	^ rolls
]

{ #category : #scoring }
Frame >> score [

	^ score
]

{ #category : #'as yet unclassified' }
Frame >> score: scoreNumber rolls: rollNumber [
	
		score := scoreNumber.
		rolls := rollNumber
]
