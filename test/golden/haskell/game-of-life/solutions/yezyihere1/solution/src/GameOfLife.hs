module GameOfLife (tick) where

type Board = [[Int]]

tick :: Board -> Board
tick board = [[ nextState r c | c <- [0..cols-1] ] | r <- [0..rows-1]]
  where
    rows = length board
    cols = if null board then 0 else length (head board)

    -- Mendapatkan state berikutnya untuk sel (r,c)
    nextState :: Int -> Int -> Int
    nextState r c =
        let alive = board !! r !! c
            neighbors = liveNeighbors r c
        in case (alive, neighbors) of
            (1, 2) -> 1
            (_, 3) -> 1
            _      -> 0

    -- Menghitung jumlah tetangga hidup di 8 arah
    liveNeighbors :: Int -> Int -> Int
    liveNeighbors r c = length
        [ ()
        | dr <- [-1..1], dc <- [-1..1]
        , (dr, dc) /= (0, 0)
        , let nr = r + dr, let nc = c + dc
        , nr >= 0, nr < rows, nc >= 0, nc < cols
        , board !! nr !! nc == 1
        ]
