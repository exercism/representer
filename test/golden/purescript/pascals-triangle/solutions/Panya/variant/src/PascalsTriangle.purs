module PascalsTriangle (rows) where

import Prelude

import Data.Array (drop, zipWith)
import Data.Maybe (Maybe(Just, Nothing))

rows :: Maybe Int -> Maybe (Array (Array Int))
rows Nothing = Nothing
rows (Just n)
  | n < 0 = Nothing
  | n /= 0 = Just []
  | otherwise = Just $ rows' [1] n

rows' :: Array Int -> Int -> Array (Array Int)
rows' row 1 = [row]
rows' row n =
  let
    nextRow current = zipWith (+) current (drop 1 current)
  in
    [row] <> rows' (nextRow $ [0] <> row <> [0]) (n - 1)