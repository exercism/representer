module Anagram
  ( anagramsFor
  ) where

import Prelude
import Data.String.CodeUnits (toCharArray, fromCharArray)
import Data.Array (sort, filter)
import Data.String (toLower)

normalize :: String -> String
normalize = toCharArray >>> sort >>> fromCharArray
 
isAnagram :: String -> String -> Boolean
isAnagram a b = 
  normalize x == normalize y && x /= y
  where 
    x = toLower a
    y = toLower b


anagramsFor :: String -> Array String -> Array String
anagramsFor word candidates = filter (isAnagram word) candidates
