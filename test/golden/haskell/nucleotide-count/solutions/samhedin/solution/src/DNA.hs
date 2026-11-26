module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromListWith, fromList, union)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs =
  maybe (Left xs) (Right . countNucleotides) (mapM nucleotide xs)
  where nucleotide c =
          case c of
            'A' -> Just A
            'C' -> Just C
            'G' -> Just G
            'T' -> Just T
            _ -> Nothing

countNucleotides :: [Nucleotide] -> Map Nucleotide Int
countNucleotides ns =
  let empty = fromList [(n, 0) | n <- [A, T, C, G]]
  in fromListWith (+) [(n, 1) | n <- ns] `union` empty
