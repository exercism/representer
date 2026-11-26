"
I keep track of the tournament standings.
"
Class {
	#name : #Tournament,
	#superclass : #Object,
	#instVars : [
		'teams',
		'results'
	],
	#category : #'Exercise@Tournament'
}

{ #category : #accessing }
Tournament >> getTeam: aName [
	^ teams at: aName ifAbsentPut: TournamentTeam new
]

{ #category : #initialization }
Tournament >> initialize [
	teams := Dictionary new.
	results := {('win'
		-> [ :a :b | 
			a won.
			b lost ]).
	('loss'
		-> [ :a :b | 
			a lost.
			b won ]).
	('draw'
		-> [ :a :b | 
			a draw.
			b draw ])} asDictionary
]

{ #category : #processing }
Tournament >> process: aString [
	| tokens teamA teamB result |
	tokens := ';' split: aString.
	tokens size = 3 or: [ self error: 'malformed input' ].
	teamA := self getTeam: (tokens at: 1).
	teamB := self getTeam: (tokens at: 2).
	result := tokens at: 3.
	(results at: result) value: teamA value: teamB
]

{ #category : #reporting }
Tournament >> report [
	| report |
	report := teams keysSortedSafely
		sorted: [ :a :b | (self getTeam: a) score < (self getTeam: b) score ].
	^ #('Team                           | MP |  W |  D |  L |  P')
		, (report reversed collect: [ :n | (teams at: n) report: n ])
]

{ #category : #processing }
Tournament >> tallyRows: aCollection [
	aCollection do: [ :line | self process: line ].
	^ self report
]
