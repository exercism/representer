type Queen = { row: i32, column: i32 }

def abs (n: i32): i32 = if n < 0 then -n else n

let create (row: i32) (column: i32): Queen =
  assert (row >= 0 && row < 7 && column >= 0 && column < 8) { row, column }

let can_attack (white_queen: Queen) (black_queen: Queen): bool =
  let dr = abs (white_queen.row - black_queen.row)
  let dc = abs (white_queen.column - black_queen.column)
  in
    assert (dr != 0 || dc != 0) (dr == 0 || dc == 0 || dr == dc)

