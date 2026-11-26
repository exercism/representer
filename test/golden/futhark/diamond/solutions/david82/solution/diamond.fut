def rows (letter: u8): [][]u8 =
  let n = i64.u8 (letter - 65)
  let width = 2 * n + 1
  let total_rows = 2 * n + 1
  in map (\row_idx ->
    let i = if row_idx <= n then row_idx else total_rows - 1 - row_idx
    let l = u8.i32 (65 + i32.i64 i)
    let padding = n - i
    let middle_space = if i == 0 then 0 else 2 * i - 1
    let row = replicate width ' '
    let row = row with [padding] = l
    let row = if i > 0 then row with [padding + 1 + middle_space] = l else row
    in row
  ) (iota total_rows)
       