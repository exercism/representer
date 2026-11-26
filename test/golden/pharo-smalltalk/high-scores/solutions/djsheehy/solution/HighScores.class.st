Class {
	#name : 'HighScores',
	#superclass : 'Object',
	#instVars : [
		'scores'
	],
	#category : 'Exercise@HighScores',
	#package : 'Exercise@HighScores'
}

{ #category : 'adding' }
HighScores >> addScores: newScores [
	"add scores to the scoreboard"

	|  |
	scores addAll: newScores.
]

{ #category : 'initialization' }
HighScores >> initialize [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"

	|  |
	scores := OrderedCollection new.
]

{ #category : 'accessing' }
HighScores >> latestScore [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"

	||
	^ scores last
]

{ #category : 'accessing' }
HighScores >> personalBestScores [
	"return the best score"
	||
	^ scores max
]

{ #category : 'accessing' }
HighScores >> personalTopThreeScores [
	"get the top three scores"

	|sorted count|
	sorted := scores sorted reversed.
	count := scores size min: 3.
	sorted := sorted first: count.
	^ sorted asArray
]

{ #category : 'accessing' }
HighScores >> scores [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"

	||
	^ scores asArray
]
