module DNA (nucleotideCounts, Nucleotide(..)) where

import qualified Data.Map.Strict as M
import Control.Monad (sequence)
import Data.List

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotideCounts :: String -> Either String (M.Map Nucleotide Int)
nucleotideCounts xs =
  case converted of
    Nothing -> Left "Invalid nucleotide sequence"
    Just l -> Right $ foldl (\m e -> M.insert (head e) (length e) m) empty $ group $ sort l
  where converted = sequence $ sort $ map convert xs

empty :: (M.Map Nucleotide Int)
empty = M.fromList [(A,0),(C,0),(G,0),(T,0)]

convert :: Char -> Maybe Nucleotide
convert 'A' = Just A
convert 'C' = Just C
convert 'G' = Just G
convert 'T' = Just T
convert _ = Nothing