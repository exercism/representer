module Matrix (saddlePoints) where

import Data.Array
import Control.Monad

type Coord = (Int, Int)

saddlePoints :: Array Coord Int -> [Coord]
saddlePoints matrix = do
    ((row, col), val) <- assocs matrix
    let rowSatisfied = all (\((r, _), v) -> r /= row || val >= v) (assocs matrix)
    let colSatisfied = all (\((_, c), v) -> c /= col || val <= v) (assocs matrix)
    guard $ rowSatisfied && colSatisfied
    return (row, col)