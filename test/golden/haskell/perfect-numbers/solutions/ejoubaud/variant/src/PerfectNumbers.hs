module PerfectNumbers (classify, Classification(..)) where

import Control.Monad (guard)

data Classification = Deficient | Perfect | Abundant deriving (Eq, Show)

classify :: Int -> Maybe Classification
classify n
  | n <= 0 = Nothing
  | aliquotSum == n = Just Perfect
  | aliquotSum >= n = Just Abundant
  | aliquotSum < n = Just Deficient
  where aliquotSum = sum (factors n) - n

factors :: Int -> [Int]
factors n = concat $ do i <- [1..(floor . sqrt . fromIntegral) n]
                        guard (n `mod` i == 0)
                        let j = n `div` i
                         in if i == j
                               then return [i]
                               else return [i,j]