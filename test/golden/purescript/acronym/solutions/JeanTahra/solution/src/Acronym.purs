module Acronym
  ( abbreviate
  ) where

import Prelude (map, ($), (<$>))
import Data.String (toUpper, joinWith)
import Data.String.Regex (Regex, match)
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.String.Regex.Flags (global)
import Data.Array.NonEmpty (toArray)
import Data.Maybe (maybe)

allFirstLettersRegex :: Regex
allFirstLettersRegex = unsafeRegex "\\b\\w|[A-Z]" global


abbreviate :: String -> String
abbreviate s = maybe "" (joinWith "")
  $ map (maybe "" toUpper)
  <$> toArray
  <$> match allFirstLettersRegex s