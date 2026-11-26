module Triangle
  ( Triangle(Equilateral, Isosceles, Scalene)
  , triangleKind
  ) where

import Prelude

import Data.Either (Either(..))

data Triangle
  = Equilateral
  | Isosceles
  | Scalene

derive instance eqTriangle :: Eq Triangle

instance showTriangle :: Show Triangle where
  show Equilateral = "Equilateral"
  show Isosceles = "Isosceles"
  show Scalene = "Scalene"

triangleKind :: Int -> Int -> Int -> Either String Triangle
triangleKind a b c =
  if not $ isValidLength a b c then Left "Invalid lengths"
  else if not $ isValidEquality a b c then Left "Violates inequality"
  else Right(
    if a == b && b == c && a == c then  Equilateral
    else if a == b || b == c || a == c then  Isosceles
    else Scalene
  )
  where
    isValidLength a b c =
      a > 0 && b > 0 && c > 0
    isValidEquality a b c =
      a + b >= c && b + c >= a && a + c >= b
