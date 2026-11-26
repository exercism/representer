module PhoneNumber exposing (getNumber)

import String exposing (startsWith, endsWith, dropLeft, filter, length)
import List exposing (any)
import Char exposing (isDigit)
import Maybe exposing (andThen)

validateCodes n =
  if any (\x -> any (startsWith x) [n, dropLeft 3 n]) ["0", "1"]
     then Nothing
     else Just n

validateLength n =
  case length n of
    10 ->
      Just n
    11 ->
      if (startsWith "1" n) then Just (dropLeft 1 n) else Nothing
    _ ->
      Nothing

getNumber : String -> Maybe String
getNumber =
  filter isDigit >> validateLength >> andThen validateCodes
