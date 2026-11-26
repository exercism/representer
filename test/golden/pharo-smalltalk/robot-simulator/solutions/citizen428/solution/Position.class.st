Class {
	#name : #Position,
	#superclass : #Object,
	#instVars : [
		'coords'
	],
	#category : #'Exercise@RobotSimulator'
}

{ #category : #'instance creation' }
Position class >> newFrom: aDictionary [
	^ self new
		  coordinates: aDictionary;
		  yourself
]

{ #category : #accessing }
Position >> advanceEast [
	coords at: 'x' update: [ :value | value + 1 ]
  
]

{ #category : #accessing }
Position >> advanceNorth [
	coords at: 'y' update: [ :value | value + 1 ]
  
]

{ #category : #accessing }
Position >> advanceSouth [
	coords at: 'y' update: [ :value | value - 1 ]
  
]

{ #category : #accessing }
Position >> advanceTowards: aDirection [
	self perform: ('advance', aDirection className) asSymbol
  
]

{ #category : #accessing }
Position >> advanceWest [
	coords at: 'x' update: [ :value | value - 1 ]
  
]

{ #category : #accessing }
Position >> coordinates [
	^ coords
]

{ #category : #accessing }
Position >> coordinates: aDictionary [
	coords := aDictionary
]
