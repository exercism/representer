def pad x y = x ++ y ++ x

def tick [n] (matrix: [n][n]i32) : [n][n]i32 =
  let matrix' = pad [replicate (1 + n + 1) 0] (map (pad [0]) matrix)
  in tabulate_2d n n (\i j ->
                        let x = i32.sum (flatten (matrix'[i:i + 3, j:j + 3]))
                        in i32.bool (if matrix[i, j] == 1
                                     then x == 3 || x == 4
                                     else x == 3))
