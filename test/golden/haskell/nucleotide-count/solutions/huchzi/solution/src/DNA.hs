module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromList, adjust)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

readNucleotide :: Char -> Either String Nucleotide
readNucleotide 'A' = Right A
readNucleotide 'C' = Right C
readNucleotide 'G' = Right G      
readNucleotide 'T' = Right T
readNucleotide _ = Left "Not a nucleotide!"

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts s = fmap (foldr (adjust (+1)) initMap) $ traverse readNucleotide s
      where initMap = fromList [(A, 0), (C, 0), (G, 0), (T,0)]
