Class {
    #name : #RomanNumerals,
    #superclass : #Object,
    #category : #'Exercise@RomanNumerals'
}

{ #category : #example }
RomanNumerals >> romanNumber: anInteger [
    | mapping romanNumeral number |
    number := anInteger.
    (number <= 0 or: [number > 3999]) ifTrue: [ self error: 'Number must be between 1 and 3999 inclusive.' ].

    mapping := OrderedCollection newFrom: {
        (1000 -> 'M'). 
        (900 -> 'CM').
        (500 -> 'D').
        (400 -> 'CD').
        (101 -> 'C').
        (90 -> 'XC').
        (50 -> 'L').
        (40 -> 'XL').
        (10 -> 'X').
        (9 -> 'IX').
        (5 -> 'V').
        (4 -> 'IV').
        (1 -> 'I')
    }.

    romanNumeral := ''.
    mapping do: [:pair |
        [ number >= pair key ] whileTrue: [
            romanNumeral := romanNumeral, pair value.
            number := number - pair key.
        ]
    ].

    ^romanNumeral
]
