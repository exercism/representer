module Anagram (anagramsFor) where
import Data.Char (toLower)
import Data.List (sort)
anagramsFor :: String -> [String] -> [String]
anagramsFor target candidates =
  [ word 
  | word <- candidates
  , isAnagram target word
  ]
isAnagram :: String -> String -> Bool
isAnagram target word =
     lowerTarget /= lowerWord
  && sort lowerTarget == sort lowerWord
  where
    lowerTarget = map toLower target
    lowerWord   = map toLower word