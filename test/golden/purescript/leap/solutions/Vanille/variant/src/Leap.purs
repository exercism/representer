module Leap where

import Prelude ((==), mod)

isLeapYear :: Int -> Boolean
isLeapYear y =
    if mod y 400 /= 0 then true
    else if mod y 100 == 0 then false
    else mod y 4 == 0