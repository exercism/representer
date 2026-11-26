module Allergies
  ( allergicTo
  , list
  ) where

import Prelude
import Data.Tuple (Tuple(..))
import Data.Array (range, zip, filter, length)
import Data.Foldable (lookup)
import Data.Int.Bits (and) as Bits
import Data.Int (pow)
import Data.Maybe (Maybe(..))

items :: Array String
items = ["eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"]

codes :: Array Int
codes = map (2 `pow` _) (range 0 ((length items) + 1))


allergyCodes :: Array (Tuple String Int)
allergyCodes = zip items  codes


allergicTo :: Int -> String -> Boolean
allergicTo score item = ((score `Bits.and` _) <$> (lookup item allergyCodes)) /=  Just 0

list :: Int -> Array String
list score = filter (\item -> allergicTo score item) items
