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
Clock class >> hour: hourNumber minute: minuteNumber [

	^ self new hour: hourNumber minute: minuteNumber
]

{ #category : #arithmetic }
Clock >> + aNumber [

	self hour: hour minute: minute + aNumber
]

{ #category : #arithmetic }
Clock >> - aNumber [

	self hour: hour minute: minute - aNumber
]

{ #category : #comparing }
Clock >> = other [

	^ other asString = self asString
]

{ #category : #converting }
Clock >> asString [

	^ '{1}:{2}' format: { 
			  (hour printPaddedWith: $0 to: 2).
			  (minute printPaddedWith: $0 to: 2) }
]

{ #category : #'as yet unclassified' }
Clock >> hour: hourNumber minute: minuteNumber [

	hour := hourNumber + (minuteNumber // 60) \\ 24.
	minute := minuteNumber \\ 60
]
