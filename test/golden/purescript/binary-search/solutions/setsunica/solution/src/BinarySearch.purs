module BinarySearch
  ( find
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Data.Array (length, (!!))

find :: forall a. Ord a => a -> Array a -> Maybe Int
find a arr = go 0 (length arr - 1)
  where
  go i k = do
    let j = (i + k) / 2
    a' <- arr !! j
    if a' == a then Just j
    else if i == k then Nothing
    else if a < a' then go i j
    else go (j + 1) k

