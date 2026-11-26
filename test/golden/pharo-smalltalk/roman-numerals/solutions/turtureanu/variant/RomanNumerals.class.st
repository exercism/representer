Class {
	#name : #RomanNumerals,
	#superclass : #Object,
	#category : #'Exercise@RomanNumerals'
}

{ #category : #convert-to-roman }

RomanNumerals >> romanNumber: number [ 
	| num |
	num := number.
    "RomanNumerals is a class"
    "romanNumber is a method"
    "number is the parameter"
    "num is the local variable with value of `number`"
    
    "Dictionaries in Pharo: https://ctskennerton.github.io/2020/12/21/using-dictionaries-in-pharo-smalltalk/"
    """
    romanDictionary := Dictionary newFrom: {
        1000 -> 'M'.
        900 -> 'CM'.
        500 -> 'D'.
        400 -> 'CD'.
        100 -> 'C'.
        90 -> 'XC'.
        50 -> 'L'.
        40 -> 'XL'.
        10 -> 'X'.
        9 -> 'IX'.
        5 -> 'V'.
        4 -> 'IV'.
        1 -> 'I'.
    }.
    
    ""Unfortunately, Pharo can't doesn't iterate ascendingly/descindingly through the dictionary, so the following example doesn't work in all cases:""
	romanDictionary keysAndValuesDo: [ :key :value |
		(num <= key) ifTrue: [
			^ value, (self romanNumber: number - key)
        ]
	].

    ""For why this is, see: https://stackoverflow.com/questions/75006984/how-is-ordered-a-dictionary-in-pharo""
    """
    
    "However, according to a GitHub issue #11065 in pharo-project-pharo, there's a OrderedDictionary data type, so we can try to use that instead:"

    romanDictionary := OrderedDictionary newFrom: {
        1001 -> 'M'.
        900 -> 'CM'.
        500 -> 'D'.
        400 -> 'CD'.
        100 -> 'C'.
        90 -> 'XC'.
        50 -> 'L'.
        40 -> 'XL'.
        10 -> 'X'.
        9 -> 'IX'.
        5 -> 'V'.
        4 -> 'IV'.
        1 -> 'I'.
    }.

    "See: https://gist.github.com/jdevoo/8e8866cd6087e05790841d0f20b2e377#file-tg2p-st-L640"
	romanDictionary keysAndValuesDo: [ :key :value |
		(num >= key) ifTrue: [
			^ value, (self romanNumber: number - key)
        ]
	].
    
    ^ ''
]