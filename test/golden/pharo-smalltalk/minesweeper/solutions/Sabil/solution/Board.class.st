Class {
    #name: #Board,
    #superclass: #Object,
    #instVars: ['cells'],
    #category: #'Exercise@Minesweeper'
}

Board class >> fromStrings: strings [
    ^ self new
        initializeFrom: strings;
        yourself
]

Board >> initializeFrom: strings [
    self
        buildCellsFrom: strings;
        connectNeighbors
]

Board >> buildCellsFrom: strings [
    cells := strings collect: [:row |
        row asArray collect: [:character |
            self cellFor: character ] ].
]

Board >> cellFor: aCharacter [
    ^ aCharacter = $*
        ifTrue: [ Mine new ]
        ifFalse: [ Cell new ]
]

Board >> cellAt: aPoint[
    ^ (cells at: aPoint x) at: aPoint y
]

Board >> includesPoint: aPoint[
    ^ (aPoint x between: 1 and: cells size)
        and: [aPoint y between: 1 and: (cells first size)]
]

Board >> cellsWithPointDo: aBlock[
    cells withIndexDo: [:row :i |
        row withIndexDo: [:cell :j |
            aBlock value: cell value: i @ j ] ]
]

Board >> neighborsOf: aPoint[
    ^ (aPoint eightNeighbors
        select: [:each | self includesPoint: each ])
        collect: [:each | self cellAt: each ]
]

Board >> annotatedStrings[
    ^ cells collect: [:row |
        String withAll: (row collect: #displayCharacter) ]
]

Board >> connectNeighbors[
    self cellsWithPointDo: [:cell :point |
        cell addNeighbors: (self neighborsOf: point) ]
]
