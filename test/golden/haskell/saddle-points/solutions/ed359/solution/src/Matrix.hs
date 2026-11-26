module Matrix (saddlePoints) where

import Data.Array (Array, (!), bounds, indices)

saddlePoints :: (Num a, Ord a) => Array (Int, Int) a -> [(Int,Int)]
saddlePoints matrix = filter (isSaddle matrix) (indices matrix)

isSaddle :: (Num a, Ord a) => Array (Int, Int) a -> (Int,Int) -> Bool
isSaddle matrix (row, col) = x == maximum xrow && x == minimum xcol
  where
    ((rowLb,colLb),(rowUb,colUb)) = bounds matrix
    x = matrix ! (row, col)
    xcol = [matrix ! (y, col) | y <- [rowLb..rowUb]]
    xrow = [matrix ! (row, z) | z <- [colLb..colUb]]