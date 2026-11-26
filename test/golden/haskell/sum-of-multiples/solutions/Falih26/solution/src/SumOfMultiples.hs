module SumOfMultiples (sumOfMultiples) where

import Data.List (nub)

sumOfMultiples :: [Integer] -> Integer -> Integer
sumOfMultiples factors limit =
  sum . nub $ [x | x <- [1 .. limit - 1], any (\f -> f /= 0 && x `mod` f == 0) factors]
