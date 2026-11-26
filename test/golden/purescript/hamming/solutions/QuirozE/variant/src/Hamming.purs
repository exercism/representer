module Hamming
  ( distance
  ) where

import Prelude (($), (+), (==))
import Data.Maybe (Maybe(..))
import Data.List (List(..), fromFoldable, (:))
import Data.String.CodeUnits as CodeUnits

distance :: String -> String -> Maybe Int
distance s1 s2 = 
    distanceL (toList s1) (toList s2) 0
    where 
      distanceL :: List Char -> List Char -> Int -> Maybe Int
      distanceL Nil Nil k = Just k
      distanceL Nil _ _ = Nothing
      distanceL _ Nil _ = Nothing
      distanceL (a:as) (b:bs) k = 
        let k' = if a /= b then k else k+1
          in distanceL as bs k'

toList :: String -> List Char
toList str = fromFoldable $ CodeUnits.toCharArray str