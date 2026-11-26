module MatchingBrackets
  ( isPaired
  ) where

import Prelude

import Data.Foldable (foldM)
import Data.List (List(..), null, uncons)
import Data.Maybe (Maybe(..), maybe)
import Data.String.CodeUnits (toCharArray)
import Data.Tuple (Tuple(..))

type Stack a = List a

push :: forall a. Stack a -> a -> Stack a
push = flip Cons

pop :: forall a. Stack a -> Maybe { head :: a, tail :: Stack a }
pop = uncons

step :: Stack Char -> Char -> Maybe (Stack Char)
step stack c = case c of
  '(' -> pushs ')'
  '[' -> pushs ']'
  '{' -> pushs '}'
  ')' -> pops ')'
  ']' -> pops ']'
  '}' -> pops '}'
  _ -> Just stack
  where
  pushs = pure <<< push stack
  pops c' = case pop stack of
    Just { head, tail } | head == c' -> Just tail
    _ -> Nothing

isPaired :: String -> Boolean
isPaired = isPaired' <<< toCharArray

isPaired' :: Array Char -> Boolean
isPaired' = maybe false null <<< foldM step Nil
