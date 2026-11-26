module Anagram (anagramsFor) where

import Data.List
import Data.Char

lower :: String -> String
lower = map toLower

normalize :: String -> String
normalize = sort . lower

anagram :: String -> String -> Bool
anagram x y = lower x /= lower y && normalize x == normalize y

anagramsFor :: String -> [String] -> [String]
anagramsFor xs xss = filter (anagram xs) xss
