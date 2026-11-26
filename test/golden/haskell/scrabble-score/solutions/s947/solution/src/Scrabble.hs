module Scrabble (scoreLetter, scoreWord) where

import Data.Char

scoreLetter :: Char -> Integer
scoreLetter letter
  | lower `elem` "aeioulnrst" = 1
  | lower `elem` "dg"         = 2
  | lower `elem` "bcmp"       = 3
  | lower `elem` "fhvwy"      = 4
  | lower `elem` "k"          = 5
  | lower `elem` "jx"         = 8
  | lower `elem` "qz"         = 10
  | otherwise = 0
  where lower = toLower letter


scoreWord :: String -> Integer
scoreWord word = sum $ map scoreLetter word

