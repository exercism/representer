module Raindrops
  ( raindrops
  ) where

import Prelude
import Data.Foldable (foldr)
import Data.String (null)
import Data.Tuple (Tuple(..))

raindrops :: Int -> String
raindrops n = if null $ res then show n else res
  where
  res =
    foldr processRaindrops ""
      [ Tuple 3 "Pling", Tuple 5 "Plang", Tuple 7 "Plong" ]

  processRaindrops (Tuple int str) acc
    | n `mod` int == 0 = str <> acc
    | otherwise = acc
