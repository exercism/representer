module AllYourBase where

import Prelude

import Data.Array (find, foldl, head)
import Data.Maybe (Maybe(..), isJust)

type Base = Int

toDigits ::  Base -> Int -> Array Int
toDigits b n = toDigits' [] n where
  toDigits' :: Array Int -> Int -> Array Int
  toDigits' acc m
    | m > 0 = toDigits' ([m `mod` b] <> acc) (m / b)
    | otherwise = acc

fromDigits :: Base -> Array Int -> Int
fromDigits b = foldl (\n x -> b * n + x) 0

invalid :: Array Int -> Boolean
invalid digits = case head digits of
  Nothing -> true
  Just 0 -> true
  _ -> false

rebase :: Int -> Int -> Array Int -> Maybe (Array Int)
rebase from to digits
  | from <= 1 = Nothing
  | to <= 1 = Nothing
  | invalid digits = Nothing
  | isJust $ find (\x -> x <= 0 || x >= from) digits = Nothing
  | otherwise = Just $ toDigits to $ fromDigits from digits