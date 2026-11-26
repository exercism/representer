Class {
	#name : #GradeSchool,
	#superclass : #Object,
	#instVars : [
		'gradeToStudents'
	],
	#category : #'Exercise@GradeSchool'
}

{ #category : #adding }
GradeSchool >> addStudents: students [

	"Adds students to the roster."

	students do: [ :e | 
		| name grade |
		name := e first.
		grade := e second.
		(gradeToStudents at: grade ifAbsentPut: [ OrderedCollection new ])
			add: name ]
]

{ #category : #'as yet unclassified' }
GradeSchool >> desiredGrade: theGrade [

	"Return all students from the desired grade"

	^ (gradeToStudents at: theGrade ifAbsent: #(  )) sorted asArray
]

{ #category : #initialization }
GradeSchool >> initialize [ 
	gradeToStudents := Dictionary new
]

{ #category : #'as yet unclassified' }
GradeSchool >> roster [

	"Return the whole roster"

	^ gradeToStudents keys sorted flatCollect: [ :key | 
		  (gradeToStudents at: key) sorted ]
]
