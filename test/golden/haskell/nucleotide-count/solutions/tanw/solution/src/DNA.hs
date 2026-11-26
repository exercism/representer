module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromList)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucs :: [Nucleotide]
nucs = [A,C,G,T]
nucStr :: String
nucStr = nucs >>= show

countChar :: String -> Char -> Int
countChar list nuc = length $ filter (== nuc) list

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs
  | all (`elem` nucStr) xs = Right $ fromList $ zip nucs (countChar xs <$> nucStr)
  | otherwise = Left xs
