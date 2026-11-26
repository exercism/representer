Class {
	#name : #Forth,
	#superclass : #Object,
	#instVars : [
		'stack',
		'builtinCommands',
		'customCommands'
	],
	#category : #'Exercise@Forth'
}

{ #category : #private }
Forth >> addCustomCommand: aCollection [
	
	| commandName commandDescription |
	commandName := aCollection second asUppercase.
	
	commandName first isDigit ifTrue: [ self error: 'illegal operation.' ].
	
	commandDescription := (aCollection allButFirst: 2) allButLast flatCollect: [ :command |
		(customCommands includesKey: command asUppercase)
			ifTrue: [ customCommands at: command asUppercase ]
			ifFalse: [ { command asUppercase } ] ].
	
	customCommands at: commandName put: commandDescription.
]

{ #category : #class }
Forth >> evaluateInstructions: aCollection [ 

	aCollection do: [ :input | | instruction | 
		instruction := input findTokens: Character space.
		(instruction first = ':' and: instruction last = ';')
			ifTrue: [ self addCustomCommand: instruction ]
			ifFalse: [ self parseInstruction: instruction ] ].
	^stack asArray reversed.
]

{ #category : #initialization }
Forth >> initialize [

	super initialize.
	stack := ForthStack new.
	builtinCommands  := Dictionary newFrom: { 
		'+' -> 'add' . 
		'-' -> 'subtract'.
		'*' -> 'multiply'.
		'/' -> 'divide'.
		'DUP' -> 'duplicate'.
		'SWAP' -> 'swap'.
		'DROP' -> 'drop'.
		'OVER' -> 'over'}.
	customCommands := Dictionary new.
]

{ #category : #private }
Forth >> interpret: aString [
		
	(customCommands includesKey: aString asUppercase)
		ifTrue: [ self parseInstruction: (customCommands at: aString asUppercase) ]
		ifFalse: [ (builtinCommands includesKey: aString asUppercase)
			ifTrue: [ stack perform: (builtinCommands at: aString asUppercase) asSymbol ]
			ifFalse: [ self error: 'undefined operation.' ] ]
		
]

{ #category : #private }
Forth >> parseInstruction: aCollection [
				
	aCollection do: [ :input | 
		(input allSatisfy: [ :char | char isDigit ]) 
			ifTrue: [ stack push: input asNumber ]
			ifFalse: [ self interpret: input ] ].

]
