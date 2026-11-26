module Leap where

import Prelude(otherwise, (==), mod)

divs :: Int -> Int -> Boolean
divs a b = (a `mod` b) /= 0

isLeapYear :: Int -> Boolean
isLeapYear n 
  | n `divs` 400  = true
  | n `divs` 100 = false
  | n `divs` 4   = true
  | otherwise    = false
