module Triangle
  ( Triangle(Equilateral, Isosceles, Scalene)
  , triangleKind
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.Array (length, nub)

data Triangle
  = Equilateral
  | Isosceles
  | Scalene

derive instance eqTriangle :: Eq Triangle
derive instance genericTriangle :: Generic Triangle _

instance showTriangle :: Show Triangle where
  show = genericShow

triangleKind :: Int -> Int -> Int -> Either String Triangle
triangleKind x y z
  | x <= 0 || y <= 0 || z <= 0 = Left "Invalid lengths"
  | x >= y + z || y >= x + z || z >= x + y = Left "Violates inequality"
  | otherwise = Right case length $ nub [x, y, z] of
                  1 -> Equilateral
                  2 -> Isosceles
                  _ -> Scalene