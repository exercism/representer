module Luhn
  ( isValid
  ) where

import           Data.Char

isValid :: String -> Bool
isValid str
  | isInvalid = False
  | otherwise = checksum digits == 0
  where
    digits = map digitToInt $ filter isDigit str
    isInvalid = not (containsValidChars str) || (length digits < 1)

containsValidChars :: String -> Bool
containsValidChars = all $ \c -> any ($ c) [isDigit, isSpace]

checksum :: [Int] -> Int
checksum = flip mod 10 . sum . op . reverse
  where
    op []       = []
    op [x]      = [x]
    op (x:y:xs) = x : doubleDigit y : op xs
    doubleDigit 9 = 9
    doubleDigit n = (n * 2) `mod` 9
