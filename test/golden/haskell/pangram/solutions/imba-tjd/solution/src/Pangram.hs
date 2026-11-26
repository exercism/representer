module Pangram (isPangram) where

import Data.Char (toLower)
isPangram :: String -> Bool
isPangram text = and [elem ch text' | ch <- chs]
    where
    text' = map toLower text
    chs = ['a'..'z']
