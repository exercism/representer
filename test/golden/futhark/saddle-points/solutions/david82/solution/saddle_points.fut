def saddle_points [m] [n] (matrix: [m][n]i32): [][2]i32 =
  if m == 0 || n == 0 then []
  else
    let candidates = flatten (tabulate m (\i -> 
      tabulate n (\j -> 
        let v = matrix[i][j]
        let row_vals = matrix[i]
        let col_vals = map (\k -> matrix[k][j]) (iota m)
        let is_row_max = all (\x -> v >= x) row_vals
        let is_col_min = all (\x -> v <= x) col_vals
        in if is_row_max && is_col_min 
           then [i32.i64 (i+1), i32.i64 (j+1)] 
           else [-1, -1]
      )
    ))
    in filter (\pos -> pos[0] != -1) candidates
      