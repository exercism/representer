"
forth
"
Class {
	#name : #Forth,
	#superclass : #Object,
	#instVars : [
		'instructionSet',
		'programStack'
	],
	#category : #'Exercise@Forth'
}

{ #category : #utilities }
Forth >> evaluateInstructions: aCollection [
	| definitions program |
	definitions := aCollection allButLast.
	self setupDefinitions: definitions.
	program := self literalizeString: aCollection last.
	program
		do: [ :literal | 
			literal isNumber
				ifTrue: [ programStack push: literal ]
				ifFalse: [ | instruction |
					instruction := instructionSet
						at: literal
						ifAbsent: [ literal = ':'
								ifTrue: [ Error signal: 'illegal operation' ]
								ifFalse: [ Error signal: 'undefined operation' ] ].
					instruction performOnStack: programStack ] ].
	^ programStack asArray reversed
]

{ #category : #initialization }
Forth >> initialize [
	instructionSet := self setupInstructionSet.
	programStack := Stack new.
]

{ #category : #utilities }
Forth >> literalizeString: aString [
	^ (aString asLowercase splitOn: ' ')
		collect: [ :literal | 
			literal isAllDigits
				ifTrue: [ literal asNumber ]
				ifFalse: [ literal asSymbol ] ]
]

{ #category : #utilities }
Forth >> setupDefinitions: someDefinitions [
	(someDefinitions
		collect: [ :rawDefinition | 
			(self literalizeString: rawDefinition asLowercase) allButFirst
				allButLast ])
		do: [ :definition | 
			| word chain |
			word := definition first.
			chain := definition allButFirst.
			instructionSet
				at: word
				put:
					(ChainedOperation new
						withOperationChain:
							(chain
								collect: [ :literal | 
									literal isNumber
										ifTrue: [ InsertOperation new withLiteral: literal ]
										ifFalse: [ instructionSet at: literal ] ])) ]
]

{ #category : #utilities }
Forth >> setupInstructionSet [
	^ Dictionary new
		at: #+
			put: (BinaryOperation new withOperationBlock: [ :a :b | {(a + b)} ]);
		at: #-
			put: (BinaryOperation new withOperationBlock: [ :a :b | {(a - b)} ]);
		at: #*
			put: (BinaryOperation new withOperationBlock: [ :a :b | {(a * b)} ]);
		at: #/
			put:
			(BinaryOperation new
				withOperationBlock: [ :a :b | 
					b = 0
						ifTrue: [ Error signal: 'divide by zero' ].
					{(a // b)} ]);
		at: #dup
			put: (UnaryOperation new withOperationBlock: [ :a | {a. a} ]);
		at: #drop 
			put: (UnaryOperation new withOperationBlock: [ :a | {} ]);
		at: #swap
			put: (BinaryOperation new withOperationBlock: [ :a :b | {b. a} ]);
		at: #over
			put: (BinaryOperation new withOperationBlock: [ :a :b | {a. b. a} ]);
		yourself
]
