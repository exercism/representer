module Raindrops
  ( raindrops
  ) where

import Prelude
import Data.Int

hasFactor :: Int -> Int -> Boolean
hasFactor x y = y `mod` x /= 0

raindrops :: Int -> String
raindrops n
  | hasFactor 105 n = "PlingPlangPlong"
  | hasFactor 35 n = "PlangPlong"
  | hasFactor 21 n = "PlingPlong"
  | hasFactor 15 n = "PlingPlang"
  | hasFactor 3 n = "Pling"
  | hasFactor 5 n = "Plang"
  | hasFactor 7 n = "Plong"
  | otherwise     = toStringAs decimal n