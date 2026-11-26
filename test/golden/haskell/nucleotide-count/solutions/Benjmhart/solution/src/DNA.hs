module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map)
import qualified Data.Map as M

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show, Read)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs 
  | not . all (`elem` "ACGT") $ xs = Left xs
  | otherwise = Right $ foldl insertNucleotide initialMap xs
  where 
    initialMap = M.fromList [(A, 0), (C, 0), (G, 0), (T, 0)]
    insertNucleotide :: Map Nucleotide Int -> Char -> Map Nucleotide Int
    insertNucleotide nucMap c = M.insertWith (\_ x -> x+1) (read [c]) 1 nucMap
