"
# ReverseString

I reverse strings.

## Usage

```
ReverseString new reverseValue: 'hello'. ""'olleh'""
```
"
Class {
	#name : #ReverseString,
	#superclass : #Object,
	#category : #'Exercise@RewerseString'
}

{ #category : #enumerating }
ReverseString >> reverseValue: aString [

	| reversed |
	reversed := Stack new.
	aString do: [ :char | reversed push: char ].
	^ String newFrom: reversed

]
