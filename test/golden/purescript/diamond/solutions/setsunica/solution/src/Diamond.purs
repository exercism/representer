module Diamond
  ( rows
  ) where

import Prelude

import Data.Array (length, mapMaybe, mapWithIndex, replicate, reverse, take, (..))
import Data.Char (fromCharCode, toCharCode)
import Data.String.CodeUnits (fromCharArray, singleton)

rows :: Char -> Array String
rows c = us <> ds
  where
  cs = toCharCode 'A' .. toCharCode c # mapMaybe fromCharCode
  n = length cs
  toLine i = case _ of
    'A' -> sw <> "A" <> sw
    c' -> let sc = singleton c' in sw <> sc <> cw <> sc <> sw
    where
    sw = replicate (n - i - 1) ' ' # fromCharArray
    cw = replicate (2 * i - 1) ' ' # fromCharArray
  us = mapWithIndex toLine cs
  ds = take (n - 1) us # reverse
