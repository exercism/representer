module Raindrops
( raindrops
) where

import Prelude
import Data.Show (show)
import Data.EuclideanRing (mod)

raindrops :: Int -> String
raindrops n | n `mod` 3 == 0 && n `mod` 5 == 0 && n `mod` 7 == 0 = "PlingPlangPlong"
raindrops n | n `mod` 3 == 0 && n `mod` 5 == 0 = "PlingPlang"
raindrops n | n `mod` 3 == 0 && n `mod` 7 == 0 = "PlingPlong"
raindrops n | n `mod` 5 == 0 && n `mod` 7 == 0 = "PlangPlong"
raindrops n | n `mod` 7 == 0 = "Plong"
raindrops n | n `mod` 5 == 0 = "Plang"
raindrops n | n `mod` 3 == 0 = "Pling"
raindrops n = show n