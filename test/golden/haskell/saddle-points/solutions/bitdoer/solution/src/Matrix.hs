module Matrix (saddlePoints) where

import Data.Array (Array, assocs, bounds, (!))

saddlePoints :: Array (Int, Int) Int -> [(Int, Int)]
saddlePoints matrix = map fst (filter (saddleIn matrix) (assocs matrix))

saddleIn :: Array (Int, Int) Int -> ((Int, Int), Int) -> Bool
saddleIn mat ((i, j), val) =
    let (m, n) = snd (bounds mat) in
        maximum [mat ! (i, k) | k <- [1..n]] == val
        && minimum [mat ! (k, j) | k <- [1..m]] == val