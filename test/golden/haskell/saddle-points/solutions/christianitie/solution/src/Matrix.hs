module Matrix (saddlePoints) where

import Data.Array

row :: Ord e => Ix i => Ix j => Array (i, j) e -> (i, j) -> [e]
row matrix a = [y | (b, y) <- (assocs matrix), fst a == fst b]

col :: Ord e => Ix i => Ix j => Array (i, j) e -> (i, j) -> [e]
col matrix a = [y | (b, y) <- (assocs matrix), snd a == snd b]

gRows :: Ord e => Ix i => Ix j => Array (i, j) e -> (i, j) -> Bool
gRows matrix a = (matrix ! a) == (maximum . (row matrix) $ a)

lCols :: Ord e => Ix i => Ix j => Array (i, j) e -> (i, j) -> Bool
lCols matrix a = (matrix ! a) == (minimum . (col matrix) $ a)

saddle :: Ord e => Ix i => Ix j => Array (i, j) e -> (i, j) -> Bool
saddle matrix a = ((gRows matrix a) && (lCols matrix a))

saddlePoints :: Ord e => Ix i => Ix j => Array (i, j) e -> [(i, j)]
saddlePoints matrix = [a | a <- (indices matrix), saddle matrix a]
