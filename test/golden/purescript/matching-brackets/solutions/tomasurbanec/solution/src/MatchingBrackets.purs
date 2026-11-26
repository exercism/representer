module MatchingBrackets
  ( isPaired
  ) where

import Data.List (List(..), (:))
import Data.String (uncons)
import Data.Maybe (Maybe(..))
import Data.Enum (fromEnum)
import Prelude

isPaired :: String -> Boolean
isPaired input = isPaired' (unconsInt input) Nil

isPaired' :: Maybe { head :: Int, tail::String} -> List Char -> Boolean
isPaired' Nothing Nil = true                                                    -- empty strings
isPaired' Nothing _ = false                                                     -- open brackets left in the end
isPaired' (Just {head: 0x0028, tail: t}) ps = isPaired' (unconsInt t) ('(':ps)  -- new open brackets
isPaired' (Just {head: 0x007B, tail: t}) ps = isPaired' (unconsInt t) ('{':ps)
isPaired' (Just {head: 0x005B, tail: t}) ps = isPaired' (unconsInt t) ('[':ps)
isPaired' (Just {head: 0x0029, tail: t}) ('(':ps) = isPaired' (unconsInt t) ps  -- matched close brackets
isPaired' (Just {head: 0x007D, tail: t}) ('{':ps) = isPaired' (unconsInt t) ps
isPaired' (Just {head: 0x005D, tail: t}) ('[':ps) = isPaired' (unconsInt t) ps
isPaired' (Just {head: 0x0029, tail: _}) _ = false                              -- unmatched close brackets
isPaired' (Just {head: 0x007D, tail: _}) _ = false
isPaired' (Just {head: 0x005D, tail: _}) _ = false
isPaired' (Just {head: _, tail: xs}) ps = isPaired' (unconsInt xs) ps           -- anything else 


unconsInt :: String -> Maybe { head :: Int, tail::String}
unconsInt input = case uncons input of
                    Just {head: h, tail: t} -> Just {head: fromEnum h, tail: t}
                    Nothing -> Nothing 
