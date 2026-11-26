module Diamond
  ( rows
  ) where

import Prelude
import Data.String.CodeUnits (toCharArray, singleton, fromCharArray)
import Data.Array (concat, reverse, takeWhile, snoc, last, replicate, cons, length)
import Data.Maybe (Maybe(..))

letters :: Array Char
letters = toCharArray "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

rows :: Char -> Array String
rows chr = concat [halfRows (Just chr),map pad $ reverse $ halfRows $ last $ takeWhile (\x -> x /= chr) letters]

halfRows :: Maybe Char -> Array String
halfRows Nothing = []
halfRows (Just 'A') = ["A"]
halfRows (Just chr) = takeWhile (\x -> x /= chr) letters
  # last
  # halfRows
  # map pad
  # addRow chr

addRow :: Char -> Array String -> Array String
addRow chr arr = snoc arr $ fromCharArray $ snoc (cons chr (replicate (2 * (length arr) +1) ' ')) chr

pad :: String -> String
pad str = " " <> str <> " "