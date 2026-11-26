Class {
	#name : #Student,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'name',
		'grade'
	],
	#category : #'Exercise@GradeSchool'
}

{ #category : #initializing }
Student class >> fromPair: pair [

	^ self new name: (pair at: 1) grade: (pair at: 2).
]

{ #category : #initializing }
Student class >> withName: aString andGrade: anInteger [ 

	^ self new name: aString grade: anInteger .
]

{ #category : #comparing }
Student >> < aStudent [

	^ self grade < aStudent grade 
						or: [ self grade = aStudent grade and: [ self name < aStudent name ] ]
]

{ #category : #comparing }
Student >> = aStudent [

	^ self grade = aStudent grade and: [ self name = aStudent name ]
]

{ #category : #accessing }
Student >> grade [
	^ grade
]

{ #category : #comparing }
Student >> hash [
	
	^ (grade hash hashMultiply + name hash) hashMultiply 
]

{ #category : #accessing }
Student >> name [
	^ name
]

{ #category : #initializing }
Student >> name: aString grade: anInteger [ 

	name := aString.
	grade := anInteger 
]
