module Leap where

import Prelude

isLeapYear :: Int -> Boolean
isLeapYear y = mod y 4 == 0
  && mod y 100 /= 0 
  || mod y 400 == 0