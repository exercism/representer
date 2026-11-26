"
I represent the results of a team.
"
Class {
	#name : #TournamentTeam,
	#superclass : #Object,
	#instVars : [
		'wins',
		'draws',
		'losses'
	],
	#category : #'Exercise@Tournament'
}

{ #category : #'changing state' }
TournamentTeam >> draw [
	draws := draws + 1
]

{ #category : #initialization }
TournamentTeam >> initialize [
	wins := 0.
	losses := 0.
	draws := 0.
]

{ #category : #'changing state' }
TournamentTeam >> lost [
	losses := losses + 1
]

{ #category : #calculating }
TournamentTeam >> matches [
	^ wins + draws + losses
]

{ #category : #reporting }
TournamentTeam >> report: aName [
	^ ' | '
		join:
			{(aName padRightTo: 30).
			(self matches asString padLeftTo: 2).
			(wins asString padLeftTo: 2).
			(draws asString padLeftTo: 2).
			(losses asString padLeftTo: 2).
			(self score asString padLeftTo: 2)}
]

{ #category : #calculating }
TournamentTeam >> score [
	^ 3 * wins + draws
]

{ #category : #'changing state' }
TournamentTeam >> won [
	wins := wins + 1
]
