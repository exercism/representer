module Hamming
  ( distance
  ) where


import Data.Array
import Data.String (length)
import Prelude
import Data.String.CodeUnits (toCharArray)
import Data.Maybe (Maybe(..))

distance :: String -> String -> Maybe Int
-- distance Nothing Nothing = Nothing
distance x y =
    if (length x /= length y) then
      Just $ foldl (+) 0 $
      zipWith (\a b -> if a==b then 0 else 1) (toCharArray x) (toCharArray y)
    else 
        Nothing  

