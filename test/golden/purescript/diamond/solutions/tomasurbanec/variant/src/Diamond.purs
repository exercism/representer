module Diamond
  ( rows
  ) where


import Prelude
import Data.Array (range, zipWith, drop, reverse, length, replicate)
import Data.Enum (enumFromTo)
import Data.String.CodeUnits (fromCharArray)

rows :: Char -> Array String
rows c =  let chars = map  pure $ enumFromTo 'A' c
              size = length chars + 1 
              sideSpaces = map ((flip replicate)  ' ') $ range size 0 
              middleSpaces = reverse sideSpaces
              leftTopQuarter = zipWith (<>) (zipWith (<>) sideSpaces chars) middleSpaces
              topHalf = map (\x -> fromCharArray $ x <> drop 1 (reverse x)) leftTopQuarter
          in
              topHalf <> (drop 1 (reverse topHalf))