module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, update, fromList)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

toNucleotide :: Char -> Either String Nucleotide
toNucleotide 'A' = Right A
toNucleotide 'C' = Right C
toNucleotide 'G' = Right G
toNucleotide 'T' = Right T
toNucleotide c   = Left $ "unrecognized nucleotide " ++ [c]

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts = fmap (foldr (update f) initCounts) . mapM toNucleotide
 where f = return . (1+)
       initCounts = fromList [ (A,0),
                               (C,0),
                               (G,0),
                               (T,0) ]
  
