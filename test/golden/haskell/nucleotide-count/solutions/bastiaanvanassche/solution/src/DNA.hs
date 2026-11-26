module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map,fromListWith)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs = fmap createMap $ toListOfNucleotides xs
    where createMap = fromListWith (+).foldl (\acc x -> (x,1) : acc) [(A,0),(C,0),(G,0),(T,0)]

toListOfNucleotides:: String -> Either String [Nucleotide]
toListOfNucleotides nucls = sequence $ foldl (\acc x -> toNucleotide x : acc) [] nucls
    where toNucleotide c = case c of 'A' -> Right A
                                     'C' -> Right C
                                     'G' -> Right G
                                     'T' -> Right T
                                     _ ->  Left nucls