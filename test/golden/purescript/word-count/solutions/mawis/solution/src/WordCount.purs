module WordCount
  ( wordCount
  ) where

import Prelude
import Data.Array (filter)
import Data.Map (Map, fromFoldableWith)
import Data.String (null, toLower)
import Data.String.Regex (replace, split)
import Data.String.Regex.Flags (noFlags)
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.Tuple (Tuple(..))

wordCount :: String -> Map String Int
wordCount = fromFoldableWith (+)
            <<< map (\w -> Tuple w 1)
            <<< filter (not <<< null)
            <<< map unquote
            <<< split (unsafeRegex "[^a-z1-9']" noFlags)
            <<< toLower
  where unquote = replace (unsafeRegex "^'(.*)'$" noFlags) "$1"
