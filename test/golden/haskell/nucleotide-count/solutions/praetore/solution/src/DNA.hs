module DNA (nucleotideCounts, Nucleotide(..)) where

import qualified Data.Map as M

data Nucleotide = A | C | G | T deriving (Eq, Ord, Show)

nucleotideCounts :: String -> Either String (M.Map Nucleotide Int)
nucleotideCounts xs = foldr checkType (Right (M.fromList [(A,0),(C,0),(G,0),(T,0)])) xs
    where checkType 'A' (Right coll) = genMap A coll
          checkType 'C' (Right coll) = genMap C coll
          checkType 'G' (Right coll) = genMap G coll
          checkType 'T' (Right coll) = genMap T coll
          checkType _  _ = Left xs
          genMap n c = Right (M.insertWith (+) n 1 c)

