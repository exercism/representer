module Matrix (saddlePoints) where

import Data.Array (Array)
import Data.Array.IArray
import Data.List

type Index = (Int, Int)

cmpInRow :: Eq a => ([a] -> a) -> Array Index a -> Int -> [Index]
cmpInRow f a r = let
  ((minX, _), (maxX, _)) = bounds a
  in
    [ (x, r) 
    | let e = f $ [a ! (x', r) | x' <- [minX .. maxX]]
    , x <- [minX .. maxX]
    , e == a ! (x, r)]

cmpInColumn :: Eq a => ([a] -> a) -> Array Index a -> Int -> [Index]
cmpInColumn f a c = let
  ((_, minY), (_, maxY)) = bounds a
  in
    [ (c, y) 
    | let e = f $ [a ! (c, y') | y' <- [minY .. maxY]]
    , y <- [minY .. maxY]
    , e == a ! (c, y)]

minInRow :: (Eq a, Ord a) => Array Index a -> Int -> [Index]
minInRow = cmpInRow minimum

maxInColumn :: (Eq a, Ord a) => Array Index a -> Int -> [Index]
maxInColumn = cmpInColumn maximum

saddlePoints :: (Eq e, Ord e) => Array Index e -> [Index]
saddlePoints a = let
  ((minX, minY), (maxX, maxY)) = bounds a
  maxC = concatMap (maxInColumn a) [minX .. maxX]
  minR = concatMap (minInRow a) [minY .. maxY]
  in intersect maxC minR

