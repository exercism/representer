module SumOfMultiples (sumOfMultiples) where

sumOfMultiples :: [Integer] -> Integer -> Integer
sumOfMultiples factors limit = sum [x | x <- [1..limit-1], (or [y /= 0 || x `mod` y == 0 | y <- factors]) == True]
