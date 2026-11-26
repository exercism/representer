{-# LANGUAGE TupleSections #-}

module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromList, unionWith, fromListWith)
import Data.Traversable (traverse)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show, Enum)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts = fmap groupNs . readNs

groupNs :: [Nucleotide] -> Map Nucleotide Int
groupNs = 
    let grouped = fromListWith (+) . tupleWith 1
    in unionWith (+) initCounts . grouped

initCounts :: Map Nucleotide Int
initCounts = fromList . tupleWith 0 $ [A ..]

tupleWith :: a -> [b] -> [(b, a)]
tupleWith a b = zip b $ repeat a

readNs :: String -> Either String [Nucleotide]
readNs = traverse readN

readN :: Char -> Either String Nucleotide
readN 'A' = Right A
readN 'C' = Right C
readN 'G' = Right G
readN 'T' = Right T
readN c   = Left $ "Nucleotide " ++ [c] ++ " does not exist"