module MatchingBrackets
  ( isPaired
  ) where

import Prelude
import Data.Array (foldl, zip)
import Data.List (List(..), (:))
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.Set as Set
import Data.String.CodeUnits (toCharArray)

isPaired :: String -> Boolean
isPaired s = foldl f Nil (toCharArray s) == Nil
  where
  pb = [ '(', '[', '{' ]
  pbs = Set.fromFoldable pb
  pem = zip [ ')', ']', '}' ] pb # Map.fromFoldable
  f acc = case _ of
    a
      | Set.member a pbs -> a : acc
      | Map.member a pem -> case acc of
          a' : acc' | Just true <- Map.lookup a pem <#> (_ == a') -> acc'
          _ -> a : acc
      | otherwise -> acc
