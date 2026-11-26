Class {
    #name: #Mine,
    #superclass: #Cell,
    #category: #'Exercise@Minesweeper'
}

Mine >> isMine [
    ^ true
]

Mine >> displayCharacter[
    ^ $*
]
