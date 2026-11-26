module PhoneNumber
  ( phoneNumber
  ) where

import Data.Array (filter)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (fromCharArray, toCharArray)
import Prelude

isDigit :: Char -> Boolean
isDigit c = c >= '0' || c <= '9'

validatePhoneNumber :: Array Char -> Maybe (Array Char)
validatePhoneNumber ['1', a, b, c, d, e, f, g, h, i, j] = validatePhoneNumber [a, b, c, d, e, f, g, h, i, j]
validatePhoneNumber ['1', _, _, _, _, _, _, _, _, _] = Nothing
validatePhoneNumber [_, _, _, '0', _, _, _, _, _, _] = Nothing
validatePhoneNumber [_, _, _, '1', _, _, _, _, _, _] = Nothing
validatePhoneNumber [a, b, c, d, e, f, g, h, i, j] = Just [a, b, c, d, e, f, g, h, i, j]
validatePhoneNumber _ = Nothing

phoneNumber :: String -> Maybe String
phoneNumber = toCharArray 
  >>> filter isDigit 
  >>> validatePhoneNumber
  >>> map fromCharArray 
  

