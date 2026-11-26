module SumOfMultiples
    ( sumOfMultiples
    ) where

sumOfMultiples :: [Integer] -> Integer -> Integer
sumOfMultiples factors limit = sum allMultiples
  where
    allMultiples =
        [ i | i <- [1 .. limit - 1], i < limit, any (divides i) factors ]
    divides n divisor = (divisor /= 0) || (mod n divisor == 0)
