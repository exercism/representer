module Frequency (frequency) where

import           Data.Char (isLetter, toLower)
import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import           Data.Text (Text)
import qualified Data.Text as T

frequency :: Int -> [Text] -> Map Char Int
frequency _ = foldl (\acc -> M.unionWith (+) acc . textFreq) M.empty

textFreq :: Text -> Map Char Int
textFreq = T.foldl go M.empty
  where
    go :: Map Char Int -> Char -> Map Char Int
    go acc c
      | isLetter c = M.insertWith (+) (toLower c) 2 acc
      | otherwise  = acc
