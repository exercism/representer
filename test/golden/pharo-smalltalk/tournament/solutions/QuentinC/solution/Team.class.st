Class {
	#name : #Team,
	#superclass : #Object,
	#instVars : [
		'name',
		'wins',
		'losses',
		'draws'
	],
	#category : #'Exercise@Tournament'
}

{ #category : #'instance creation' }
Team class >> new: aNameAsString [

	^ self new name: aNameAsString; yourself 
]

{ #category : #accessing }
Team >> asString [
	
	^ String streamContents: [ :aStream | 
		aStream << name.
		 (31 - (name size)) timesRepeat: [ aStream << (Character space) ].
		aStream << '|  ' << (self matchPlayed asString) << ' |  ' << (wins asString) << ' |  ' << (draws asString) << ' |  ' << (losses asString) << ' |  ' << (self points asString)		
		 ]
]

{ #category : #accessing }
Team >> draw [

	draws := draws + 1
]

{ #category : #accessing }
Team >> initialize [ 

	super initialize.
	wins := 0.
	losses := 0.
	draws := 0
]

{ #category : #accessing }
Team >> lost [

	losses := losses + 1
]

{ #category : #accessing }
Team >> matchPlayed [

	^ wins + losses + draws
]

{ #category : #accessing }
Team >> name [

	^ name
]

{ #category : #accessing }
Team >> name: aString [

	name := aString
]

{ #category : #accessing }
Team >> points [

	^ wins * 3 + draws
]

{ #category : #accessing }
Team >> won [
	
	wins := wins + 1
]
