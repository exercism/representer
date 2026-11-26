module AllYourBase
  ( rebase
  ) where

import Prelude

import Data.Array (find, fromFoldable, mapWithIndex, reverse, head)
import Data.Foldable (foldM, sum)
import Data.Int (pow)
import Data.List.Lazy (iterate, takeWhile)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Unfoldable (unfoldr)

-- import Data.Unfoldable (unfoldr)

rebase :: Int -> Int -> Array Int -> Maybe (Array Int)
rebase fb tb s 
  | not isValidNumInBase fb s || not isValidBase tb = Nothing
  | otherwise = rebaseIntM tb <$> parseToIntM fb s

-- base, int array, to a maybe value
parseToIntM :: Int -> Array Int -> Maybe Int
parseToIntM base ary =
  foldM
    (\acc dig -> 
        if isValidDig base dig 
        then Just $ acc * base + dig 
        else Nothing)
    0
    ary

rebaseIntM :: Int -> Int -> Array Int
rebaseIntM base n = reverse $ unfoldr rb n
  where
  rb n' | n' <= 0 || base <2 = Nothing
        | otherwise = Just $ Tuple (mod n' base) (n' / base)

isValidBase :: Int -> Boolean
isValidBase base = base > 1

isValidDig :: Int -> Int -> Boolean
isValidDig base dig = base > 1 && dig >=0 && dig < base

isValidNumInBase :: Int -> Array Int -> Boolean
isValidNumInBase base ary 
    | base < 2 = false
    | otherwise =
        (case ary of
            [] -> false
            [0] -> false
            ary' -> 
                (not firstZero) && rightDig
                where
                    firstZero = case head ary of
                        Just i -> i == 0
                        Nothing -> false
                    rightDig = case find (\i -> i < 0 || i >= base) ary of
                        Nothing -> true
                        Just _ -> false)
