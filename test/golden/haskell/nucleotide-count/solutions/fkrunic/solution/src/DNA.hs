module DNA (nucleotideCounts, Nucleotide(..)) where

import Control.Monad (foldM)
import Data.Map (Map, insertWith, fromList)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)
type Tally = Map Nucleotide Int

trans :: Char -> Either Char Nucleotide
trans 'A' = Right A
trans 'C' = Right C
trans 'G' = Right G
trans 'T' = Right T
trans x = Left x

update :: Tally -> Nucleotide -> Tally
update m n = insertWith (+) n 1 m

folder :: Tally -> Char -> Either Char Tally
folder m c = trans c >>= Right . update m

nucleotideCounts :: String -> Either Char Tally
nucleotideCounts = foldM folder zero
    where zero = fromList [(A, 0), (C, 0), (G, 0), (T, 0)]
