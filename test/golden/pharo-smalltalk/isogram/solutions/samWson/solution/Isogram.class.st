"
# Isogram

I detect if a phrase contains any repeated characters, excluding 
hyphens and spaces.

## Usage

```
Isogram new isIsogramPhrase: 'Isogram' ""true""
```

## Instance Variables

- ignoredCharacters: A collection of characters that are allowed to be repeated in a phrase.
"
Class {
	#name : #Isogram,
	#superclass : #Object,
	#instVars : [
		'ignoredCharacters'
	],
	#category : #'Exercism-Isogram'
}

{ #category : #initialization }
Isogram >> initialize [

	ignoredCharacters := { Character space. $-. }
]

{ #category : #grammar }
Isogram >> isIsogramPhrase: aString [

	| tally |
	tally := Bag new.
	aString 
		reject: [ :char | ignoredCharacters includes: char ] 
		thenDo: [ :char | tally add: char asLowercase ].

	^ (tally valuesAndCounts anySatisfy: [ :value | value > 1 ]) not
]
