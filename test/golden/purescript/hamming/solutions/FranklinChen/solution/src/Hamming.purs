module Hamming
  ( distance
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Data.String (length)
import Data.String.Unsafe (charAt)

distance :: String -> String -> Maybe Int
distance s1 s2 =
  let
    s1Length = length s1

    go i count
      | i >= s1Length = count
      | charAt i s1 == charAt i s2 = go (i + 1) count
      | otherwise = go (i + 1) (count + 1)
  in
    if s1Length /= length s2 then Nothing
    else
      Just $ go 0 0
