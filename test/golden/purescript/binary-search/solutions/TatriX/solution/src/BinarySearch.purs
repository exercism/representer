module BinarySearch
  ( find
  ) where

import Prelude

import Data.Array (length, unsafeIndex)
import Data.Maybe (Maybe(..))
import Partial.Unsafe (unsafePartial)

find :: forall a. Show a => Ord a => a -> Array a -> Maybe Int
find x xs = go 0 $ length xs where
  go left right
    | left > right = Nothing
    | otherwise =
      let middle = (left + right) / 2 in
      case unsafePartial $ unsafeIndex xs middle of
        elem | elem > x -> go left (middle - 1)
        elem | elem < x -> go (middle + 1) right
        otherwise -> Just middle