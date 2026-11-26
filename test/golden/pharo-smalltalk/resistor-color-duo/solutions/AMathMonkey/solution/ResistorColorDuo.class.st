Class {
	#name : #ResistorColorDuo,
	#superclass : #Object,
	#category : #'Exercise@ResistorColorDuo'
}

ResistorColorDuo >> colorIndex [
   ^ #('black' 'brown' 'red' 'orange' 'yellow' 'green' 'blue' 'violet' 'grey' 'white')
]

ResistorColorDuo >> valueWithColors: colorList [
    |indices|
    indices := (colorList first: 2) collect: [:c | 
        |i|
        i := self colorIndex indexOf: c.
        (i = 0) ifTrue: [self error: 'Invalid color'].
        (i - 1) printString
    ].
    ^ ('' join: indices) asNumber
]
