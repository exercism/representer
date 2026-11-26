module Scrabble (scoreLetter, scoreWord) where

import Data.List (find)
import Data.Char (toUpper)

scoreLetter :: Char -> Integer
scoreLetter ch = maybe 0 snd (find (elem (toUpper ch) . fst) scoreMap)
  where scoreMap = [
          ("AEIOULNRST", 1),
          ("DG", 3),
          ("BCMP", 3),
          ("FHVWY", 4),
          ("K", 5),
          ("JX", 8),
          ("QZ", 10)
                   ]


scoreWord :: String -> Integer
scoreWord = sum . map scoreLetter