module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromList)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs
  | any (\c -> not (elem c "ACGT")) xs = Left("Invalid nucleotide")
  | otherwise = Right(fromList
                      [(A, (numNuc 'A')),
                       (C, (numNuc 'C')),
                       (G, (numNuc 'G')),
                       (T, (numNuc 'T'))])
  where
    numNuc nc = length (filter (\c -> nc == c) xs)

