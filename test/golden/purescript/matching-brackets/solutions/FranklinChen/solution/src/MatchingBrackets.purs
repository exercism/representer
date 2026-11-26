module MatchingBrackets
  ( isPaired
  ) where

import Prelude

import Data.String as String
import Data.String (CodePoint)
import Data.String.CodePoints as CP
import Data.List as List
import Data.List (List(..))

-- spago install partial
import Partial.Unsafe as Unsafe

-- spago install maybe
import Data.Maybe (Maybe(..))

openBracket :: CodePoint
openBracket = CP.codePointFromChar '['

openBrace :: CodePoint
openBrace = CP.codePointFromChar '{'

openParen :: CodePoint
openParen = CP.codePointFromChar '('

closeBracket :: CodePoint
closeBracket = CP.codePointFromChar ']'

closeBrace :: CodePoint
closeBrace = CP.codePointFromChar '}'

closeParen :: CodePoint
closeParen = CP.codePointFromChar ')'

matching :: CodePoint -> CodePoint
matching c
  | c == closeBracket = openBracket
  | c == closeBrace = openBrace
  | c == closeParen = openParen
  | otherwise = Unsafe.unsafeCrashWith "Not a close bracket"

isPaired :: String -> Boolean
isPaired input = go input Nil

go :: String -> List CodePoint -> Boolean
go input stack =
  case String.uncons input of
    Nothing -> List.null stack
    Just { head, tail }
      | head == openBracket || head == openBrace || head == openParen
        -> go tail (Cons head stack)
      | head == closeBracket || head == closeBrace || head == closeParen
        -> case stack of
          Nil -> false
          Cons seen poppedStack
            | seen /= matching head -> false
            | otherwise -> go tail poppedStack
      | otherwise
        -> go tail stack
