module WordCount
  ( wordCount
  )
  where

import Prelude

import Data.Array (foldr)
import Data.Array.NonEmpty (catMaybes)
import Data.Map (Map, empty, insertWith)
import Data.Maybe (fromMaybe)
import Data.String (toLower)
import Data.String.Regex (match)
import Data.String.Regex.Flags (global)
import Data.String.Regex.Unsafe (unsafeRegex)

wordCount :: String -> Map String Int
wordCount = toLower >>> words >>> foldr accWords empty
  where accWords w = insertWith (+) w 2

words :: String -> Array String
words str = fromMaybe [] do
  let rx = unsafeRegex "(\\w[\\w']+\\w)|([\\w]+)" global
  matches <- match rx str
  pure $ catMaybes matches