"
# Grade School

Given students' names along with the grade that they are in, create a roster
for the school.

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	students:		<Object>


    Implementation Points
"
Class {
	#name : #GradeSchool,
	#superclass : #Object,
	#instVars : [
		'students'
	],
	#category : #'Exercise@GradeSchool'
}

{ #category : #exercism }
GradeSchool >> addStudents: aCollection [ 
	aCollection do: [ :arr | self students add: (arr at: 1) -> (arr at: 2) ]
]

{ #category : #exercism }
GradeSchool >> desiredGrade: anInteger [
	"returns a sorted Array of the students in the input grade"

 	^ ( self students select: [ :pair | pair value = anInteger  ] ) keys asArray sorted
]

{ #category : #initialization }
GradeSchool >> initialize [ 
	self students: Dictionary new.
]

{ #category : #exercism }
GradeSchool >> roster [
	^  ( (1 to: 12) flatCollect: [ :grade | self desiredGrade:  grade  ] ) asArray.
]

{ #category : #accessing }
GradeSchool >> students [
	^ students
]

{ #category : #accessing }
GradeSchool >> students: anObject [
	students := anObject
]
