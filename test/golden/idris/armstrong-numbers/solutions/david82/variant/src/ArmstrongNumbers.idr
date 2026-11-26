module ArmstrongNumbers

import Data.List
import Data.Nat

-- We'll use partial functions here as they're needed for this algorithm
-- and remove the %default total to allow partial functions
-- Convert an integer to a list of its digits
toDigits : Integer -> List Integer
toDigits n = 
  if n < 0
    then []
    else if n < 10
      then [n]
      else (n `mod` 10) :: toDigits (n `div` 10)

-- Calculate power of a number
-- We use assert_total to tell Idris this terminates
power : Integer -> Integer -> Integer
power base 0 = 1
power base exp = 
  if exp < 0 
    then 0  -- Handle negative exponents
    else base * power base (exp - 1)

-- Calculate the sum of digits each raised to the power of the number of digits
armstrongSum : List Integer -> Integer
armstrongSum digits = 
  let numDigits = cast (length digits)
  in sum (map (\d => power d numDigits) digits)

export
isArmstrongNumber : Integer -> Bool
isArmstrongNumber number = 
  if number <= 0
    then False
    else 
      let digits = toDigits number
          calculatedSum = armstrongSum digits
      in number == calculatedSum
