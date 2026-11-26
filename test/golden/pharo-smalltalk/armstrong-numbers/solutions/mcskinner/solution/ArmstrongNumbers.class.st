Class {
    #name : #ArmstrongNumbers,
    #superclass : #Object,
    #category : #'Exercism@ArmstrongNumbers'
}

Number >> digits [
    | val result |
    val := self .
    result := OrderedCollection new .
    [ val > 0 ] whileTrue: [
        result add: (val rem: 10) .
        val := val // 10
    ] .
    ^ result
]

Number >> numDigits [
    ^ self digits size
]

ArmstrongNumbers >> isArmstrongNumber: aNumber [
    | raisedDigits |
    raisedDigits := aNumber digits collect: [ :each | each raisedTo: (aNumber numDigits) ] .
    ^ aNumber == (raisedDigits sum)
]