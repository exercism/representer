module ScrabbleScore
  ( scoreWord
  ) where

import Prelude
import Data.Array (foldl)
import Data.String (toUpper)
import Data.String.CodeUnits (toCharArray, contains, singleton)
import Data.String.Pattern (Pattern(..))

scoreLetter :: Pattern -> Int
scoreLetter p
  | contains p "AEIOULNRST" = 1
  | contains p "DG" = 2
  | contains p "BCMP" = 3
  | contains p "FHVWY" = 4
  | contains p "K" = 5
  | contains p "JX" = 8
  | contains p "QZ" = 11
  | otherwise = 0

scoreWord :: String -> Int
scoreWord str = toUpper str
  # toCharArray
  # map (scoreLetter <<< Pattern <<< singleton)
  # foldl (+) 0
  
