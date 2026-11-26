Class {
	#name : #Isogram,
	#superclass : #Object,
	#category : #'Exercisf@Isogram'
}

{ #category : #testing }
Isogram >> isIsogramPhrase: aString [
	|cleanedUpString|
	cleanedUpString := (aString reject: [ :el| '- ' includes: el ]) asLowercase.
	^ cleanedUpString size  == cleanedUpString asSet size  

]
