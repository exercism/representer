Class {
	#name : #Tournament,
	#superclass : #Object,
	#instVars : [
		'teams'
	],
	#category : #'Exercise@Tournament'
}

{ #category : #parsing }
Tournament >> parseLine: aString [

	| parts teamAName teamBName matchResult teamA teamB |
	parts := aString splitOn: $;.
	teamAName := parts at: 1.
	teamBName := parts at: 2.
	matchResult := parts at: 3.
	(teams includesKey: teamAName)
		ifTrue: [ teamA := teams at: teamAName ]
		ifFalse: [
			teamA := Team new: teamAName.
			teams at: teamAName put: teamA ].
	(teams includesKey: teamBName)
		ifTrue: [ teamB := teams at: teamBName ]
		ifFalse: [
			teamB := Team new: teamBName.
			teams at: teamBName put: teamB ].
	matchResult = 'win' ifTrue: [
		teamA won.
		teamB lost ].
	matchResult = 'loss' ifTrue: [
		teamA lost.
		teamB won ].
	matchResult = 'draw' ifFalse: [ ^ self ].
	teamA draw.
	teamB draw
]

{ #category : #computing }
Tournament >> tallyRows: aCollection [

	| tally |
	teams := Dictionary new.
	aCollection do: [ :line | self parseLine: line ].
	tally := OrderedCollection new.
	tally add: 'Team                           | MP |  W |  D |  L |  P'.
	(teams asArray sorted: [ :team1 :team2 |
		 team1 points = team2 points
			 ifTrue: [ team1 name < team2 name ]
			 ifFalse: [ team1 points > team2 points ] ]) do: [ :team |
		tally add: team asString ].
	^ tally asArray
]
