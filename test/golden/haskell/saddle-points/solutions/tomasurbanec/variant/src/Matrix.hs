module Matrix (saddlePoints) where

import Data.Array (Array, indices, bounds, (!))

saddlePoints :: Ord e => Array (Int, Int) e -> [(Int, Int)]
saddlePoints matrix = filter ((flip isSaddlePoint) matrix) (indices matrix)


isSaddlePoint ::  Ord e => (Int, Int) -> Array (Int, Int) e -> Bool
isSaddlePoint ind@(row,col) array = let bnds = (snd . bounds) array
                                    in and  $ [(array ! ind) < array ! (x, col) | x <- [1 .. fst bnds]]
                                               ++ [(array ! ind) >= array ! (row, x) | x <- [1 .. snd bnds]]