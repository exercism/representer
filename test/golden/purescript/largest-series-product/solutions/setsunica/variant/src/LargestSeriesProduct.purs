module LargestSeriesProduct
  ( largestProduct
  ) where

import Prelude

import Data.Array ((..))
import Data.Array as Array
import Data.CodePoint.Unicode (decDigitToInt)
import Data.Foldable (maximum, product)
import Data.Maybe (Maybe(..))
import Data.String (toCodePointArray)
import Data.Traversable (traverse)

largestProduct :: String -> Int -> Maybe Int
largestProduct s i = do
  ns <- traverse decDigitToInt $ toCodePointArray s
  let len = Array.length ns
  if i <= 0 || len <= i then Nothing
  else maximum do
    start <- 0 .. (len - i)
    let span = Array.slice start (start + i) ns
    pure $ product span
