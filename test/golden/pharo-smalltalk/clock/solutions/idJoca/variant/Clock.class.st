Class {
	#name : #Clock,
	#superclass : #Object,
	#instVars : [
		'hour',
		'minute'
	],
	#category : #'Exercise@Clock'
}

{ #category : #'as yet unclassified' }
Clock class >> hour: aHour minute: aMinute [
	"I instantiate a Clock, with the given hours and minutes"

	^ self new
		addHour: aHour;
		addMinute: aMinute;
		yourself 
]

{ #category : #arithmetic }
Clock >> + aMinute [
	"Proxy to addMinute:."
	
^ self addMinute: aMinute 
]

{ #category : #arithmetic }
Clock >> - aMinute [
	"Proxy for substractMinute:."
	
^ self subtractMinute: aMinute
]

{ #category : #comparing }
Clock >> = aClock [
	"Proxy for equals:."
	
^ self equals: aClock
]

{ #category : #adding }
Clock >> addHour: aHour [
	"I add hours to myself."

	"Hours great than 24 will overflow."

	hour := (hour + aHour) \\ 24
]

{ #category : #adding }
Clock >> addMinute: aMinute [
	"I add minutes to myself."

	"Minutes great than 60 will overflow into hours."


	
	self addHour: (minute + aMinute) // 60.
	minute := (minute + aMinute) \\ 60.
]

{ #category : #converting }
Clock >> asString [
	"I answer a formatted version of my time"

	^ '{hour}:{minute}'
		format:
			{(#hour -> (hour asString padLeftTo: 2 with: $0)).
			(#minute -> (minute asString padLeftTo: 3 with: $0 ))} asDictionary
]

{ #category : #comparing }
Clock >> equals: aClock [
	"I check if the given clock is equal to myself"

	^ (minute = aClock minute) and: [ hour = aClock hour ]
]

{ #category : #accessing }
Clock >> hour [
	^ hour
]

{ #category : #initialization }
Clock >> initialize [
	"I initialize myself."
	super initialize.
	hour := 0.
	minute := 0.
]

{ #category : #accessing }
Clock >> minute [
	^ minute
]

{ #category : #'as yet unclassified' }
Clock >> subtractMinute: aMinute [
	"I substract minutes from myself."
	
	^ self addMinute: (aMinute abs negated)
]
