module Etl
  ( transform
  ) where

import Prelude
import Data.Map (Map, fromFoldable, toUnfoldable)
import Data.Array (concatMap)
import Data.Tuple (Tuple(..))
import Data.String (toLower)
import Data.String.CodeUnits (singleton)
import Data.String.Unsafe (char)

transform :: Map Int (Array Char) -> Map Char Int
transform m = toUnfoldable m
  # concatMap (\(Tuple i letters) -> filter (\c -> Tuple (singleton c # toLower # char) i) letters)
  # fromFoldable
