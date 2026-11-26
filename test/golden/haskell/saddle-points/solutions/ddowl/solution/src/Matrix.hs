module Matrix
  ( saddlePoints
  )
where

import           Data.Array

type MatIx = (Int, Int)

saddlePoints :: (Ord e, Show e) => Array MatIx e -> [MatIx]
saddlePoints matrix =
  let ixs = range $ bounds matrix in filter (isSaddlePoint matrix ixs) ixs

isSaddlePoint :: (Ord e, Show e) => Array MatIx e -> [MatIx] -> MatIx -> Bool
isSaddlePoint matrix ixs ix =
  let currPoint = matrix ! ix
      (x, y)    = ix
      rowIxs    = filter ((== x) . fst) ixs
      colIxs    = filter ((== y) . snd) ixs
      rowElems  = map (matrix !) rowIxs
      colElems  = map (matrix !) colIxs
      maxInRow  = currPoint == maximum rowElems
      minInCol  = currPoint == minimum colElems
  in  maxInRow && minInCol
