{-# LANGUAGE TupleSections #-}

module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map)
import Data.Map.Strict (fromList, fromListWith, union)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

base :: Char -> Either String Nucleotide
base 'A' = Right A
base 'C' = Right C
base 'G' = Right G
base 'T' = Right T
base x   = Left $ "Invalid base " ++ [x]

zeros :: Map Nucleotide Int
zeros = fromList [(A, 0), (C, 0), (G, 0), (T, 0)]

count :: [Nucleotide] -> Map Nucleotide Int
count = (`union` zeros) . fromListWith (+) . (map (, 1))

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts = fmap count . sequence . map base
