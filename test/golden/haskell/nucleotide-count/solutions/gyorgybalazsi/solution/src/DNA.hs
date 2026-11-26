module DNA (nucleotideCounts, Nucleotide(..)) where

import Data.Map (Map, fromList, unionWith)
import Data.List

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotideCounts :: String -> Either String (Map Nucleotide Int)
nucleotideCounts xs = case mapM trFun xs of Left unhappyRes -> Left unhappyRes
                                            Right happyRes -> Right . countNucs $ happyRes
                                            

trFun :: Char -> Either String Nucleotide
trFun c = case c of 'A' -> Right A
                    'C' -> Right C
                    'G' -> Right G
                    'T' -> Right T
                    _ -> Left [c]

countNucs :: [Nucleotide] -> Map Nucleotide Int
countNucs ns = unionWith (+) (fromList [(A,0),(C,0),(G,0),(T,0)]) 
    (fromList $ map (\g@(n:_) -> (n, length g)) . group . sort $ ns)
