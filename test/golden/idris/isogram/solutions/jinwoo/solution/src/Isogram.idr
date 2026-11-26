module Isogram

import Data.SortedSet
import Data.String

export
isIsogram : String -> Bool
isIsogram phrase = go empty (unpack (toLower phrase))
  where
    go : SortedSet Char -> List Char -> Bool
    go _    []        = True
    go seen (x :: xs) = if contains x seen then False
                        else if isAlpha x then go (insert x seen) xs
                        else go seen xs
