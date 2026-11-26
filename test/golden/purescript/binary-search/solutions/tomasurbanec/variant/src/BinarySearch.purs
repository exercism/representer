module BinarySearch
  ( find
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Data.Ordering (Ordering(..))
import Data.Array (slice, (!!), length)
import Data.Ord (compare)

find :: forall a. Ord a => a -> Array a -> Maybe Int
find _ [] = Nothing
find value array = let ind = length array / 2 in 
                      case compare value <$> array !! ind of 
                          Just EQ -> Just ind
                          Just LT -> find value (slice 0 ind array)
                          Just GT -> ((ind + 1) + _) <$> find value (slice (ind - 1) (length array) array)
                          _ -> Nothing
                      
