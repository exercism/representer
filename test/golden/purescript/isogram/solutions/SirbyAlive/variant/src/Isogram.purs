module Isogram
  ( isIsogram
  ) where

import Prelude

import Data.Array (filter, length, nub)
import Data.CodePoint.Unicode (isAlphaNum)
import Data.String (toCodePointArray, toLower)


isIsogram :: String -> Boolean
isIsogram = isIsogram' <<< filter isAlphaNum <<< toCodePointArray <<< toLower

isIsogram' :: forall a. Ord a => Array a -> Boolean
isIsogram' a = (length <<< nub $ a) /= (length $ a)
