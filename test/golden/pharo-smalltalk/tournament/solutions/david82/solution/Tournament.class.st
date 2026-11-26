Class {
    #name : #Tournament,
    #superclass : #Object,
    #instVars : [ 'teams' ],
    #classVars : [ ],
    #category : #'Exercise@Tournament'
}

{ #category : #constants }
Tournament class >> pointsForResult [
    "Return points awarded for each result type"
    ^ Dictionary newFromPairs: { 
        'win' . 3 . 
        'draw' . 1 . 
        'loss' . 0 
    }
]

{ #category : #constants }
Tournament class >> oppositeResult: result [
    "Return the opposite result from the guest team's perspective"
    ^ (Dictionary newFromPairs: {
        'win' . 'loss' .
        'loss' . 'win' .
        'draw' . 'draw'
    }) at: result
]

{ #category : #initialization }
Tournament >> initialize [
    "Initialize tournament with empty team statistics"
    super initialize.
    teams := Dictionary new
]

{ #category : #'private - parsing' }
Tournament >> parseMatch: matchString [
    "Parse a match result string and update team statistics"
    | parts team1 team2 result |
    parts := matchString substrings: ';'.
    team1 := parts at: 1.
    team2 := parts at: 2.
    result := parts at: 3.
    
    self updateTeam: team1 withResult: result.
    self updateTeam: team2 withResult: (self class oppositeResult: result)
]

{ #category : #'private - updating' }
Tournament >> updateTeam: teamName withResult: result [
    "Update team statistics based on match result"
    | teamKey stats |
    teamKey := teamName padRightTo: 30.
    
    "Ensure team exists with initial stats: [MP, W, D, L, P]"
    teams at: teamKey ifAbsentPut: [ Array new: 5 withAll: 0 ].
    
    stats := teams at: teamKey.
    
    "Update matches played"
    stats at: 1 put: (stats at: 1) + 1.
    
    "Update specific result counter and points"
    self updateStatsArray: stats forResult: result
]

{ #category : #'private - updating' }
Tournament >> updateStatsArray: statsArray forResult: result [
    "Update the statistics array for a specific result"
    | resultIndex points resultMapping |
    
    "Create mapping dictionary"
    resultMapping := Dictionary newFromPairs: {
        'win' . 2 .
        'draw' . 3 .
        'loss' . 4
    }.
    
    "Determine which statistic to update: W=2, D=3, L=4"
    resultIndex := resultMapping at: result.
    
    "Update the result counter"
    statsArray at: resultIndex put: (statsArray at: resultIndex) + 1.
    
    "Update points (index 5)"
    points := self class pointsForResult at: result.
    statsArray at: 5 put: (statsArray at: 5) + points
]

{ #category : #'private - formatting' }
Tournament >> formatTeamRow: teamName withStats: stats [
    "Format a team's statistics as a table row string"
    | formattedStats |
    formattedStats := stats collect: [ :value | value asString padLeftTo: 2 ].
    ^ ' | ' join: (Array with: teamName), formattedStats
]

{ #category : #'private - sorting' }
Tournament >> sortedTeamEntries [
    "Return team entries sorted by points (desc) then name (asc)"
    ^ teams associations sorted: [ :a :b |
        | pointsA pointsB |
        pointsA := a value at: 5.  "Points are at index 5"
        pointsB := b value at: 5.
        
        pointsA = pointsB
            ifTrue: [ a key <= b key ]  "Alphabetical when points are equal"
            ifFalse: [ pointsA > pointsB ]  "Descending by points"
    ]
]

{ #category : #'private - constants' }
Tournament >> tableHeader [
    "Return the formatted table header"
    ^ 'Team                           | MP |  W |  D |  L |  P'
]

{ #category : #api }
Tournament >> tallyRows: matchResults [
    "Process match results and return formatted table as array of strings"
    | result |
    
    "Reset tournament state"
    self initialize.
    
    "Process all matches"
    matchResults do: [ :match | self parseMatch: match ].
    
    "Build formatted result"
    result := OrderedCollection new.
    result add: self tableHeader.
    
    "Add sorted team rows"
    self sortedTeamEntries do: [ :teamEntry |
        result add: (self formatTeamRow: teamEntry key withStats: teamEntry value)
    ].
    
    ^ result asArray
]
