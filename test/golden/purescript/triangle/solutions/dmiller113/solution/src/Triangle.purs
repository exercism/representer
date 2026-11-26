module Triangle
  ( Triangle(Equilateral, Isosceles, Scalene)
  , triangleKind
  ) where

import Prelude (class Eq, class Show, otherwise, show, (&&), (+), (==), (>), (>=), (||))
import Data.Either (Either(..))

data Triangle
  = Equilateral
  | Isosceles
  | Scalene

instance triangleEq :: Eq Triangle where
  eq Equilateral Equilateral = true
  eq Isosceles Isosceles = true
  eq Scalene Scalene = true
  eq a _ = false

instance triangleShow :: Show Triangle where
  show Equilateral = show "Equilateral"
  show Isosceles = show "Isosceles"
  show Scalene = show "Scalene"

chooseTriangle :: Int -> Int -> Int -> Triangle
chooseTriangle g h i
  | (g == h) && (h == i) = Equilateral
  | (g == h) ||
    (h == i) ||
    (i == g) = Isosceles
  | otherwise = Scalene

triangleInequality :: Int -> Int -> Int -> Either String Triangle
triangleInequality d e f
  | (d + e >= f) &&
    (e + f >= d) &&
    (f + d >= e) = Right (chooseTriangle e d f)
  | otherwise = Left "Violates inequality"

verifyTriangle :: Int -> Int -> Int -> Either String Triangle
verifyTriangle a b c
  | (a > 0) && (b > 0) && (c > 0) = triangleInequality a b c
  | otherwise = Left "Invalid lengths"

triangleKind :: Int -> Int -> Int -> Either String Triangle
triangleKind = verifyTriangle