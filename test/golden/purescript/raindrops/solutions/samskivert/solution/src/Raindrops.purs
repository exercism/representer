module Raindrops
  ( raindrops
  ) where

import Prelude
import Data.Maybe(Maybe(..), fromMaybe)

raindrops :: Int -> String
raindrops r = fromMaybe (show r) (sound r)
  where sound     n = (plxng 3 "i" n) <> (plxng 5 "a" n) <> (plxng 7 "o" n)
        plxng m s n = if (n `mod` m == 0) then Just("Pl" <> s <> "ng") else Nothing