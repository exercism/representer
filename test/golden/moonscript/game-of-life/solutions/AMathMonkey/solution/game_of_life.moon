count_live_neighbors = (grid, i, j) ->
  res = 0
  for {i1, j1} in *{
    {i - 1, j - 1}
    {i - 1, j}
    {i - 1, j + 1}
    {i, j - 1}
    {i, j + 1}
    {i + 1, j - 1}
    {i + 1, j}
    {i + 1, j + 1}
  } do res += 1 if (grid[i1] or {})[j1] == 1
  res

tick: (matrix) ->
  res = [[0 for _ = 1, #row] for row in *matrix]
  for i = 1, #matrix
    for j = 1, #matrix[i]
      live_neighbors = count_live_neighbors matrix, i, j
      res[i][j] = 1 if live_neighbors == 3 or (live_neighbors == 2 and matrix[i][j] == 1) 
  res
