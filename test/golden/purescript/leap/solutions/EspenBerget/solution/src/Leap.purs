module Leap where

import Prelude

isLeapYear :: Int -> Boolean
isLeapYear year = divides year 4 && (not (divides year 100) || divides year 400)
    where
      divides :: Int -> Int -> Boolean
      divides n m = n `mod` m == 0