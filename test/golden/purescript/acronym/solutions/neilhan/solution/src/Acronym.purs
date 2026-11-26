module Acronym
  ( abbreviate
  ) where

import Prelude

import Data.Array (catMaybes, head)
import Data.String (Pattern(..), joinWith, split, take, toUpper)
import Data.String.CodeUnits (fromCharArray, toCharArray)
import Data.String.Regex (replace)
import Data.String.Regex.Flags (global)
import Data.String.Regex.Unsafe (unsafeRegex)

abbreviate :: String -> String
abbreviate = 
  separateMixCase
  >>> replace (unsafeRegex "[^\\w]" global) " "
  >>> split (Pattern " ")
  >>> map (take 1) -- map (\w -> head $ toCharArray w)
  >>> joinWith ""
  >>> toUpper

separateMixCase :: String -> String
separateMixCase = replace (unsafeRegex "([a-z])([A-Z])" global) "$1 $2"


--   >>> catMaybes
--   >>> fromCharArray