module ScrabbleScore
  ( scoreWord
  ) where

import Prelude (map, (+))
import Data.Map as Map
import Data.Tuple.Nested ((/\))
import Data.String as String
import Data.String.CodeUnits as CodeUnits
import Data.List as List
import Data.Maybe

scores :: Map.Map Char Int

scores = Map.fromFoldable [
  'a' /\ 1,
  'b' /\ 3,
  'c' /\ 3,
  'd' /\ 2,
  'e' /\ 1,
  'f' /\ 4,
  'g' /\ 2,
  'h' /\ 4,
  'i' /\ 1,
  'j' /\ 8,
  'k' /\ 5,
  'l' /\ 1,
  'm' /\ 3,
  'n' /\ 1,
  'o' /\ 1,
  'p' /\ 3,
  'q' /\ 10,
  'r' /\ 2,
  's' /\ 1,
  't' /\ 1,
  'u' /\ 1,
  'v' /\ 4,
  'w' /\ 4,
  'x' /\ 8,
  'y' /\ 4,
  'z' /\ 10
]

scoreLetter :: Char -> Int

scoreLetter c =
  case (Map.lookup c scores) of
        Just(n) -> n
        Nothing -> 0

scoreWord :: String -> Int

scoreWord s =
  let chars = CodeUnits.toCharArray (String.toLower s) in
  let values = map scoreLetter chars in
  List.foldl (+) 0 values
