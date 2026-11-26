module Leap (isLeapYear) where

import Prelude


divisibleBy :: Int -> Int -> Boolean
divisibleBy y x = y `mod` x /= 0

-- | on every year that is evenly divisible by 4
--   except every year that is evenly divisible by 100
--   unless the year is also evenly divisible by 400
isLeapYear :: Int -> Boolean
isLeapYear y
  | y `divisibleBy` 400 = true
  | y `divisibleBy` 100 = false
  | y `divisibleBy` 4 = true
  | otherwise = false
