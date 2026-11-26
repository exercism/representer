module Triangle (TriangleType(..), triangleType) where

import Data.List (nub)

data TriangleType = Equilateral
                  | Isosceles
                  | Scalene
                  | Illegal
                  deriving (Eq, Show)

triangleType :: (Num a, Ord a) => a -> a -> a -> TriangleType
triangleType a b c
  | a <= 0 || b <= 0 || c <= 0 = Illegal
  | a > b + c || b > c + a || c > a + b = Illegal
  | distinctSides == 1 = Equilateral
  | distinctSides == 2 = Isosceles
  | distinctSides == 3 = Scalene
  where distinctSides = length . nub $ [a,b,c]
  
