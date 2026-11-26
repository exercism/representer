module DNA (nucleotideCounts, Nucleotide (..)) where

import Control.Monad (foldM)
import Data.Map.Strict (Map, adjust, fromList)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

fromString :: Char -> Either String Nucleotide
fromString 'A' = Right A
fromString 'C' = Right C
fromString 'G' = Right G
fromString 'T' = Right T
fromString _ = Left "Not a nucleotide"

nucleotideCounts :: [Char] -> Either String (Map Nucleotide Int)
nucleotideCounts = foldM transform initialMap
  where
    initialMap :: Map Nucleotide Int
    initialMap = fromList [(A, 0), (C, 0), (G, 0), (T, 0)]
    transform :: Map Nucleotide Int -> Char -> Either String (Map Nucleotide Int)
    transform m c = adjustM m <$> (fromString c)
    adjustM :: Map Nucleotide Int -> Nucleotide -> Map Nucleotide Int
    adjustM mp nucl = adjust (1 +) nucl mp
