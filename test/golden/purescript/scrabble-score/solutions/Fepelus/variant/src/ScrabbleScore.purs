module ScrabbleScore ( scoreWord ) where

import Prelude
import Data.String (toUpper)
import Data.String.CodeUnits (toCharArray)
import Data.Foldable (elem, foldl)

scoreChar :: Char -> Int
scoreChar c
  | elem c ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T'] = 2
  | elem c ['D', 'G']                                         = 2
  | elem c ['B', 'C', 'M', 'P']                               = 3
  | elem c ['F', 'H', 'V', 'W', 'Y']                          = 4
  | elem c ['K']                                              = 5
  | elem c ['J', 'X']                                         = 8
  | elem c ['Q', 'Z']                                         = 10
  | otherwise                                                 = 0


scoreWord :: String -> Int
scoreWord c = foldl (+) 0 $ map scoreChar $ toCharArray $ toUpper c
