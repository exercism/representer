module PascalsTriangle (rows) where

import Prelude

import Data.Array (zipWith, (:))
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Data.Unfoldable (unfoldr)

rows :: Maybe Int -> Maybe (Array (Array Int))
rows Nothing = Nothing
rows (Just n)
  | n < 0 = Nothing
  | n == 0 = Just []
  | otherwise = Just $ [ 1 ] : unfoldr f (1 /\ [ 1 ])
      where
      f (i /\ r)
        | n - 1 < i = Nothing
        | otherwise = Just $ r' /\ ((i + 1) /\ r')
            where
            r' = zipWith (+) (r <> [ 0 ]) (0 : r)
