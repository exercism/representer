module Leap where
import Prelude
import Data.Int (rem)

isLeapYear :: Int -> Boolean
isLeapYear year =  year `rem` 4   == 0
               && (year `rem` 100 /= 0
               ||  year `rem` 400 == 0)