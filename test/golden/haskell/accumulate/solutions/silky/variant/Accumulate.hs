module Accumulate where

accumulate :: (a -> b) -> [a] -> [b]
accumulate f = foldl (\x y -> [f x] ++ y) []