module Triangle
  ( Triangle(Equilateral, Isosceles, Scalene)
  , triangleKind
  ) where

import Prelude
import Data.Either (Either(..))
--import Effect.Exception.Unsafe (unsafeThrow)

data Triangle
  = Equilateral
  | Isosceles
  | Scalene

derive instance eqTriangle :: Eq Triangle

instance showTriangle :: Show Triangle where
  show _ = "" -- not specified in instructions; not tested; do not know what is expected

triangleKind :: Int -> Int -> Int -> Either String Triangle
triangleKind a b c | a <= 0 || b <= 0 || c <= 0 = Left "Invalid lengths"
                   | a + b < c || a + c < b || b + c < a = Left "Violates inequality"
                   | a == b && b == c = Right Equilateral
                   | a == b || a == c || b == c = Right Isosceles
                   | otherwise = Right Scalene
