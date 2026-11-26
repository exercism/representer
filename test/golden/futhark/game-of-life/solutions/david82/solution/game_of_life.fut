-- Compute the next generation for an n x n matrix of 0/1 cells.
def tick [n] (matrix: [n][n]i32): [n][n]i32 =
  -- The eight neighbor offsets (exclude (0,0)).
  let neighbors =
    [ (-1, -1), (-1,  0), (-1,  1)
    , ( 0, -1),           ( 0,  1)
    , ( 1, -1), ( 1,  0), ( 1,  1)
    ]

  in tabulate_2d n n (\i j ->
    let live = matrix[i, j]
    let count =
      reduce (+) 0 (map (\(di, dj) ->
        let ii = i + di
        let jj = j + dj
        in if 0 <= ii && ii < n && 0 <= jj && jj < n
           then matrix[ii, jj] else 0
      ) neighbors)

    in if live == 1
       then if count == 2 || count == 3 then 1 else 0
       else if count == 3 then 1 else 0
  )
  