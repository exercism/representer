module Palindromes (largestPalindrome, smallestPalindrome) where

largestPalindrome :: Integer -> Integer -> Maybe (Integer, [(Integer, Integer)])
largestPalindrome minFactor maxFactor =
  foldr
    compareProduct
    Nothing
    $ palindromeProducts minFactor maxFactor
  where
    compareProduct something Nothing = Just something
    compareProduct (p, factors) (Just (currentMax, currentFactors))
      | p > currentMax = Just (p, factors)
      | p == currentMax = Just (currentMax, currentFactors ++ factors)
      | otherwise = Just (currentMax, currentFactors)

smallestPalindrome :: Integer -> Integer -> Maybe (Integer, [(Integer, Integer)])
smallestPalindrome minFactor maxFactor =
  foldr
    compareProduct
    Nothing
    $ palindromeProducts minFactor maxFactor
  where
    compareProduct something Nothing = Just something
    compareProduct (p, factors) (Just (currentMin, currentFactors))
      | p < currentMin = Just (p, factors)
      | p == currentMin = Just (currentMin, currentFactors ++ factors)
      | otherwise = Just (currentMin, currentFactors)

palindromeProducts :: Integer -> Integer -> [(Integer, [(Integer, Integer)])]
palindromeProducts minFactor maxFactor =
  [ (x * y, [(x, y)]) | x <- [minFactor .. maxFactor], y <- [minFactor .. x], isPalindrome (x * y)
  ]

isPalindrome :: Integer -> Bool
isPalindrome n = digits == reverse digits
  where
    digits = show n
