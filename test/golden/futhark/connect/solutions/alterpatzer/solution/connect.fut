def contents [m] [n] (board: [m][n]u8) (r: i64) (c: i64): u8 =
  board[r][r + 2 * c]

def columns (m: i64) (n: i64): i64 = 1 + (n - m) / 2

def initialO [m] [n] (board: [m][n]u8): [](i64, i64) =
  loop os = []
  for c < columns m n do
    if contents board 0 c == 'O' then os ++ [(0, c)] else os

def initialX [m] [n] (board: [m][n]u8): [](i64, i64) =
  loop xs = []
  for r < m do
    if contents board r 0 == 'X' then xs ++ [(r, 0)] else xs

def finalO [m] [n] (board: [m][n]u8) (r: i64) (c: i64): bool =
  r == m - 1 && contents board r c == 'O'

def finalX [m] [n] (board: [m][n]u8) (r: i64) (c: i64) =
  c == (columns m n) - 1 && contents board r c == 'X'

def neighbors [m] [n] [p]
      (board: [m][n]u8)
      (letter: u8)
      (r: i64) (c: i64)
      (visited: [m][p]bool): [](i64, i64) =
  filter (\(i, j) -> i >= 0 && j >= 0 &&
          i < m && j < p &&
          !visited[i][j] && contents board i j == letter)
         [(r - 1, c), (r - 1, c + 1),
          (r, c - 1), (r, c + 1),
          (r + 1, c - 1), (r + 1, c)]

def connects [m] [n] (board: [m][n]u8)
                     (letter: u8)
                     (initial: [m][n]u8 -> [](i64, i64))
                     (final: [m][n]u8 -> i64 -> i64 -> bool): bool =
  let cols = columns m n
  let (joined, _, _) =
    loop (_, q, visited) =
      (false, initial board, replicate m (replicate cols false))
      while length q != 0 do
        let g = head q
        let rest = tail q
        let vup = copy visited with [g.0, g.1] = true
        in
          if final board g.0 g.1
          then (true, [], vup)
          else (false, rest ++ neighbors board letter g.0 g.1 visited, vup)
  in joined
 
def winner [m] [n] (board: [m][n]u8): u8 =
  if connects board 'O' initialO finalO then 'O'
  else if connects board 'X' initialX finalX then 'X'
  else '.'
