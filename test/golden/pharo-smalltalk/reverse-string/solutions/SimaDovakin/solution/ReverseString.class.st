Class {
    #name: #ReverseString,
    #superclass: #Object,
    #category: #'Exercise@ReverseString'
}

ReverseString >> reverseValue: str [
    |reversedRange resultStream|

    str isEmpty ifTrue: [ ^ '' ].

    reversedRange := Interval from: str size to: 1 by: -1.
    resultStream := WriteStream on: String new.
    reversedRange do: [ :n | resultStream nextPut: (str at: n) ].
    ^ resultStream contents.
]