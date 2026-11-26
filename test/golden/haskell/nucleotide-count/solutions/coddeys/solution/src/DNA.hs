module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromList, insertWith)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts  =
  fmap frequency . toDNA

frequency :: [Nucleotide] -> (Map Nucleotide Int)
frequency =
  foldl
    (\ys n -> insertWith (+) n 1 ys)
    (fromList [(A, 0), (C, 0), (G, 0), (T, 0)])


toDNA :: String -> Either String [Nucleotide]
toDNA str = traverse fromChar str
  where
    fromChar 'A' = Right A
    fromChar 'C' = Right C
    fromChar 'G' = Right G
    fromChar 'T' = Right T
    fromChar _ = Left str
