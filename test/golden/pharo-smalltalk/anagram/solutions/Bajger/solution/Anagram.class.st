Class {
	#name : #Anagram,
	#superclass : #Object,
	#category : #'Exercise@Anagram'
}

{ #category : #'string-testing' }
Anagram >> findAnagramsCandidates: listOfCandidates subject: subjectString [

	"candidate word is anagram of subject string, if case-insensitive bags made from them are equal and
	 candidate word is not same as subject string (ignoring case sensitivity)
	"
	|subjectStringBag |
	subjectStringBag := subjectString asLowercase asBag.
	^ listOfCandidates
		select: [ :aCandidateString | 
			aCandidateString asLowercase asBag = subjectStringBag
				and: [ (aCandidateString sameAs: subjectString) not ] ]
]
