module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map)
import qualified Data.Map as M

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

toNucleotide :: Char -> Either String Nucleotide
toNucleotide 'A' = Right A
toNucleotide 'C' = Right C
toNucleotide 'G' = Right G
toNucleotide 'T' = Right T
toNucleotide c   = Left $ show c <> " is not a Nucleotide"

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts s =
  case traverse toNucleotide s of
    Left e  -> Left $ "Error: " <> e
    Right ns  -> Right $ foldr (M.adjust (+1)) initMap ns
      where
        initMap = M.fromList [(A, 0), (C, 0), (G, 0), (T, 0)]
