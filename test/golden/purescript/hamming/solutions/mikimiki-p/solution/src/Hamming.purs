module Hamming (distance) where

import Prelude

import Data.Array (filter, zipWith, length)
import Data.Function (on)
import Data.Maybe (Maybe(..))
import Data.String as String

hamming :: forall t. Eq t => Array t -> Array t -> Maybe Int
hamming a b | on (==) length a b = Just $ length $ filter (not) $ zipWith (==) a b
            | otherwise = Nothing

distance :: String -> String -> Maybe Int
distance = on hamming String.toCodePointArray
