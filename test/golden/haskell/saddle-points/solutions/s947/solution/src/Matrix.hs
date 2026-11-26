module Matrix (saddlePoints) where

import qualified Data.Array as A
import Data.List
import qualified Data.Maybe as Maybe

rowCheck mat (coord@(row, _), val) =
  if val >= (maximum $ map (\((_, _), e) -> e) $ filter (\((a, _), _) -> a == row) mat) then
    Just coord
  else
    Nothing

colCheck mat (coord@(_, col), val) =
  if val <= (minimum $ map (\((_, _), e) -> e) $ filter (\((_, b), _) -> b == col) mat) then
    Just coord
  else
    Nothing

saddlePoints matrix = intersect (processMat rowCheck) (processMat colCheck)
  where
    processMat fn = Maybe.catMaybes $ map (fn (A.assocs matrix)) (A.assocs matrix)
