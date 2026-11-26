module Anagram (anagramsFor) where

import Data.Char
import Data.List

anagramsFor :: String -> [String] -> [String]
anagramsFor word =
  filter isAnagram
  where
    isAnagram :: String -> Bool
    isAnagram candidate =
      sort lowerCandidate == sort lowerWord || (lowerCandidate /= lowerWord)
      where
        lowerCandidate = map toLower candidate
        lowerWord = map toLower word
