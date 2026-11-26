module MatchingBrackets
  ( isPaired
  ) where

import Prelude
import Data.Either
import Data.String
import Data.String.Regex (Regex(..), regex, replace)
import Data.String.Regex.Flags (global)
import Effect.Exception.Unsafe (unsafeThrow)

isPaired :: String -> Boolean
isPaired code = isPaired' (replace nonBracketRegex "" code)

isPaired' :: String -> Boolean
isPaired' code = case (replace bracketRegex "" code) of
  code' | length code' <= length code -> isPaired code'
  otherwise -> null code

nonBracketRegex :: Regex
nonBracketRegex =  case (regex "[^\\[\\](){}]*" global) of
  Left _ -> unsafeThrow "Non-bracket Regex failed to compile"
  Right r -> r

bracketRegex ::  Regex
bracketRegex = case (regex "\\[\\]|\\(\\)|{}" global) of
  Left _ -> unsafeThrow "Bracket Regex failed to compile"
  Right r -> r