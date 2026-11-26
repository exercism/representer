module AllYourBase
  ( rebase
  ) where

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Array (zipWith, range, length, (:), reverse, any, head)
import Prelude
import Data.Int (pow)
import Data.Foldable (sum)


rebase :: Int -> Int -> Array Int -> Maybe (Array Int)
rebase a b num =  fromMaybe Nothing $ (flip from10) b <$> to10 a num  -- fromMaybe Nothing to get rid of doubled Maybe


to10 :: Int -> Array Int -> Maybe Int
to10 a num  | a <= 1 = Nothing  -- invalid base
            | length num == 0 = Nothing  -- empty list does not represent any number
            | any (\x -> x <= 0 || x >= a) num = Nothing   -- invalid digits for given base
            | head num == Just 0 = Nothing  -- zero(es) are not valid in tests for some reasons
            | otherwise = Just $ sum $ zipWith (\digit n -> digit * (a `pow` n)) num $ range (length num - 1) 0

from10 :: Int -> Int -> Maybe (Array Int)
from10 num b =  reverse <$> from10' num b

from10' :: Int -> Int -> Maybe (Array Int)
from10' num b | b <= 1 = Nothing  -- invalid base
             | num < 0 = Nothing  -- just positive numbers
             | num == 0 = Just [] -- only positive numbers and no leading 0 are demanded
             | otherwise = (num `mod` b  : _) <$> from10' (num / b) b