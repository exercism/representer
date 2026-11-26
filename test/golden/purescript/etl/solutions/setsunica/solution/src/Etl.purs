module Etl
  ( transform
  ) where

import Prelude

import Data.Map (Map)
import Data.Map as Map
import Data.String (toLower)
import Data.String.CodeUnits (singleton)
import Data.String.Unsafe (char)
import Data.Tuple.Nested ((/\))

transform :: Map Int (Array Char) -> Map Char Int
transform m = Map.fromFoldable do
  i /\ cs <- Map.toUnfoldable m
  c <- char <<< toLower <<< singleton <$> cs
  pure $ c /\ i
