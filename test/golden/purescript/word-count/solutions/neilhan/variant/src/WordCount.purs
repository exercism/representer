module WordCount
  ( wordCount
  , cleanString
  ) where

import Prelude

import Data.Array (foldl, foldr)
import Data.Map (Map, alter, empty, fromFoldable)
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), split, toLower, trim)
import Data.String.Regex (replace)
import Data.String.Regex.Flags (global)
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.Tuple (Tuple(..))

wordCount :: String -> Map String Int
wordCount =
  cleanString
    >>> split (Pattern " ")
    >>> foldl countWord empty

cleanString :: String -> String
cleanString =
  toLower
    >>> replace (unsafeRegex "[^a-zA-Z0-9']+" global) " "
    >>> replace (unsafeRegex "( ')|(' )|(^')|('$)" global) " "
    >>> replace (unsafeRegex " +" global) " "
    >>> trim

countWord :: Map String Int -> String -> Map String Int
countWord m w =
  let
    alt :: Maybe Int -> Maybe Int
    alt Nothing = Just 1

    alt (Just c) = Just $ c - 1
  in
    alter alt w m
