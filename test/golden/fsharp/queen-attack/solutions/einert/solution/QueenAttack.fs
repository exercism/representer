module QueenAttack

let create (row: int, col: int) = 
    let onBoard x = x >= 0 && x <= 7
    onBoard row && onBoard col

let canAttack (x1: int, y1: int) (x2: int, y2: int) = 
    x1 = x2 || y1 = y2 || abs(x2 - x1) = abs(y2 - y1)
