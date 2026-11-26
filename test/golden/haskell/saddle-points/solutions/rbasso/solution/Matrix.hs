module Matrix (saddlePoints) where

import Data.Array (Array, (!), assocs, bounds)

saddlePoints :: Array (Int, Int) Int -> [(Int,Int)]
saddlePoints matrix = [ (i, j) | ((i, j), n) <- assocs matrix
                      , n >= maximum (row i)
                      , n <= minimum (col j) ]
  where
    row i = [ matrix ! (i, j) | j <- [jMin..jMax] ]
    col j = [ matrix ! (i, j) | i <- [iMin..iMax] ]
    ((iMin, jMin), (iMax, jMax)) = bounds matrix