Class {
	#name : #GradeSchool,
	#superclass : #Object,
	#instVars : [
		'roster'
	],
	#category : #'Exercise@GradeSchool'
}

{ #category : #adding }
GradeSchool >> addStudents: aCollection [

	roster addAll: (aCollection collect: [ :p | Student fromPair: p ])
]

{ #category : #accessing }
GradeSchool >> desiredGrade: anInteger [ 
	
	^ (roster select: [ :s | s grade = anInteger ] thenCollect: #name) asArray
]

{ #category : #adding }
GradeSchool >> initialize [ 
	roster := SortedCollection new
]

{ #category : #accessing }
GradeSchool >> roster [
	
	^ (roster collect: #name) asArray 
]
