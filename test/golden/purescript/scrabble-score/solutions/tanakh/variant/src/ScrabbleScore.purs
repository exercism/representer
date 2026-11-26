module ScrabbleScore
  ( scoreWord
  ) where

import Prelude

import Data.Array (elem)
import Data.Foldable (sum)
import Data.String (toUpper)
import Data.String.CodeUnits

scoreWord :: String -> Int
scoreWord s =
  sum $ map score $ toCharArray $ toUpper s

score :: Char -> Int
score c
  | c `elem` ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T'] = 1
  | c `elem` ['D', 'G'] = 2
  | c `elem` ['B', 'C', 'M', 'P'] = 3
  | c `elem` ['F', 'H', 'V', 'W', 'Y'] = 4
  | c `elem` ['K'] = 6
  | c `elem` ['J', 'X'] = 8
  | c `elem` ['Q', 'Z'] = 10
  | otherwise = 0
