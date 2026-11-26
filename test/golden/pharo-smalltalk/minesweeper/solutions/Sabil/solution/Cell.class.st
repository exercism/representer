Class {
    #name: #Cell,
    #superclass: #Object,
    #instVars: ['neighbors'],
    #category: #'Exercise@Minesweeper'
}

Cell >> initialize [
    neighbors := OrderedCollection new
]

Cell >> addNeighbors: aCollection [
    neighbors addAll: aCollection
]

Cell >> neighboringMineCount [
    ^ neighbors
        count: #isMine
]

Cell >> isMine [
    ^ false
]

Cell >> displayCharacter [
    ^ ' 12345678' at: self neighboringMineCount + 1
]
