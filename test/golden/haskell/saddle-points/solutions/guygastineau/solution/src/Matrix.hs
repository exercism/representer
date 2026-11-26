module Matrix (saddlePoints) where

import Data.Array (Array, assocs, bounds, listArray, (!))
import Data.List (groupBy, sortOn)
import Control.Arrow ((***), (&&&))

saddlePoints :: Ord e => Array (Int, Int) e -> [(Int, Int)]
saddlePoints matrix = map fst . filter isSaddle $ assocs matrix
  where
    (start, end) = bounds matrix

    isSaddle ((row, col), value) =
      (rowMaxes ! row) == value && (colMinis ! col) == value

    (rowMaxes, colMinis) = (rowCompute &&& colCompute) . assocs $ matrix

    rowCompute = listArray (fst start, fst end)
             . vecProperty sameRow maximum

    colCompute = listArray (snd start, snd end)
             . vecProperty sameCol minimum
             . sortOn (snd . fst)

    vecProperty vecFun propFun =
      map (propFun . map snd) . groupBy ((uncurry vecFun .) . indices)
      where
        indices = curry $ fst *** fst

-- Simple Helpers
sameRow :: (Int, Int) -> (Int, Int) -> Bool
sameRow = (uncurry (==) .) . curry (fst *** fst)

sameCol :: (Int, Int) -> (Int, Int) -> Bool
sameCol = (uncurry (==) .) . curry (snd *** snd)
