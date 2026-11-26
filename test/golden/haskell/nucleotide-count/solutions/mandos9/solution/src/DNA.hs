module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromList, adjust)
import Data.Traversable (mapAccumR)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

type NucleotideCount = Either String (Map Nucleotide Int)


nucleotideCounts :: String -> NucleotideCount
nucleotideCounts xs = fmap (foldr folding counts) (traverse validate xs)
    where 
        counts :: Map Nucleotide Int
        counts = fromList [(A, 0), (C,0), (G, 0), (T,0)]
        conversion :: [(Char, Nucleotide)]
        conversion = [('A', A), ('C', C), ('G', G), ('T', T)]
        validate :: Char -> Either String Nucleotide
        validate c = case lookup c conversion 
                     of   Nothing -> Left [c]
                          Just n  -> Right n
        folding n ms = adjust (+ 1) n ms