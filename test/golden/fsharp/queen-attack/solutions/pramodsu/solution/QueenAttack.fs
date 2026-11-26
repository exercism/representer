module QueenAttack

let create (position: int * int) = 
  let (i, j) = position
  i >= 0 && i < 8 && j >= 0 && j < 8

let canAttack (queen1: int * int) (queen2: int * int) = 
  let (i1, j1) = queen1
  let (i2, j2) = queen2
  i1 = i2 || j1 = j2 || abs(i1 - i2) = abs(j1 - j2)