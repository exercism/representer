module IsbnVerifier (isbn) where

import Data.Char

isbn :: String -> Bool
isbn s = valid && 0 == isbnSum `mod` 11
  where
    digits = filter (/= '-') s
    valid = (10 == length digits) && (\c -> isDigit c || 'X' == c) (last digits) && all isDigit (take 9 digits)
    isbnSum = sum $ zipWith (*) (map charToInt digits) [10, 9 ..]

    charToInt 'X' = 10
    charToInt d = digitToInt d
