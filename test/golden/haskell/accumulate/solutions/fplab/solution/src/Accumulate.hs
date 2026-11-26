module Accumulate (accumulate) where

accumulate :: (a -> b) -> [a] -> [b]
accumulate f xs = map' xs
  where
    map' []      = []
    map' (x:xs') = f x : map' xs'
