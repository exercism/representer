{-# LANGUAGE LambdaCase #-}

module DNA (nucleotideCounts, Nucleotide(..)) where

import qualified Data.Map.Strict as M
import Data.Map.Strict (Map, insertWith)

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

parseNuc :: Char -> Either String Nucleotide
parseNuc = \case
  'A' -> Right A
  'C' -> Right C
  'G' -> Right G
  'T' -> Right T
  c -> Left $ c : " is not a valid Nucleotide"

doCounts :: [Nucleotide] -> Map Nucleotide Int
doCounts = foldl (\counts nuc -> insertWith (+) nuc 1 counts)
                 (M.fromList [(A, 0), (C, 0), (G, 0), (T, 0)])

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs = doCounts <$> traverse parseNuc xs
