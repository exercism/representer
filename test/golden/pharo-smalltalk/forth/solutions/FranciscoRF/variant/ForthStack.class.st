Class {
	#name : #ForthStack,
	#superclass : #Stack,
	#category : #'Exercise@Forth'
}

{ #category : #operating }
ForthStack >> add [
	
	self validateSize: 2.
	^self push: self pop + self pop
]

{ #category : #operating }
ForthStack >> divide [
	
	| temp |
	self validateSize: 2.
	temp := self pop.
	temp isZero ifTrue: [ self error: 'Cannot divide by zero.' ].
	^self push: self pop // temp.
]

{ #category : #operating }
ForthStack >> drop [
	
	self validateSize: 1.
	^self pop
]

{ #category : #operating }
ForthStack >> duplicate [
	
	self validateSize: 2.
	^self push: (self at: 1)
]

{ #category : #operating }
ForthStack >> multiply [
	
	self validateSize: 2.
	^self push: self pop * self pop
]

{ #category : #operating }
ForthStack >> over [

	self validateSize: 2.
	^self push: (self at: 2)
]

{ #category : #operating }
ForthStack >> subtract [
	
	| temp |
	self validateSize: 2.
	temp := self pop.
	^self push: self pop - temp.
]

{ #category : #operating }
ForthStack >> swap [
	
	| temp1 temp2 |
	self validateSize: 2.
	temp1 := self pop.
	temp2 := self pop.
	^self push: temp1; push: temp2; yourself.
]

{ #category : #operating }
ForthStack >> validateSize: anInteger [
	
	self size < anInteger ifTrue: [ self error: 'Insufficient elements in stack for operation (empty stack or only one value on the stack).' ]
]
