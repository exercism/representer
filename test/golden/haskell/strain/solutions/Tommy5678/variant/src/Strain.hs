module Strain (keep, discard) where

discard :: (a -> Bool) -> [a] -> [a]
discard p xs = map (\x -> not (p x)) xs

keep :: (a -> Bool) -> [a] -> [a]
keep p xs = filter (\x -> p x) xs
