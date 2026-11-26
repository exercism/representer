module Hamming (distance) where

import Prelude

import Data.Array (filter, length, zip)
import Data.Maybe (Maybe(..))
import Data.String (length) as String 
import Data.String.CodeUnits (toCharArray)
import Data.Tuple (fst, snd)


distance :: String -> String -> Maybe Int
distance xs ys
  | String.length xs /= String.length ys = Nothing
  | otherwise = Just $ length $ filter (\p -> fst p `not eq` snd p) $ zip (toCharArray xs) (toCharArray ys)