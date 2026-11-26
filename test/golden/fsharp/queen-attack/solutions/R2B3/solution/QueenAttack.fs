module QueenAttack

let create ((row, col): int * int): bool =
    row >= 0 && row <= 7 && col >= 0 && col <= 7

let canAttack (queen1: int * int) (queen2: int * int): bool =
    let (row1, col1) = queen1
    let (row2, col2) = queen2

    abs (row1 - row2) = abs (col1 - col2)
    || row1 = row2
    || col1 = col2
