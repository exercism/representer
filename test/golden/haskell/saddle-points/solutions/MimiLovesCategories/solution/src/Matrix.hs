module Matrix (saddlePoints) where

import Data.Array (Array, bounds, assocs)

type Index = (Int, Int)

saddlePoints :: Ord e => Array Index e -> [Index]
saddlePoints matrix = [ind | ind<-allMaxes, ind `elem` allMins]
    where allMins = [x | col <- getCols matrix, x <- focusPoints minimum col]
          allMaxes = [x | row <- getRows matrix, x <- focusPoints maximum row]

focusPoints :: Ord e => ([e] -> e) -> [(Index, e)] -> [Index]
focusPoints f row = [index | (index, val) <- row, val == maxVal]
    where maxVal = (f . map snd) row

getCols :: Array Index e -> [[(Index, e)]]
getCols matrix = [ [ass | ass <- assocs matrix, snd (fst ass) == col] | col <- [minCol..maxCol]]
    where minCol = snd . fst . bounds $ matrix
          maxCol = snd . snd . bounds $ matrix

getRows :: Array Index e -> [[(Index, e)]]
getRows matrix = [ [ass | ass <- assocs matrix, fst (fst ass) == row] | row <- [minRow..maxRow]]
    where minRow = fst . fst . bounds $ matrix
          maxRow = fst . snd . bounds $ matrix