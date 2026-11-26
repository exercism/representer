module Anagram ( anagramsFor ) where

import Prelude
import Data.String (Pattern(Pattern), split, toUpper)
import Data.Array (sort, filter)
import Data.Foldable (foldl)

type WordSignature = String

type SignedWord =
  { word :: String
  , signature  :: WordSignature
  }

signatureOf :: String -> WordSignature
signatureOf w = foldl (<>) "" sortedChars
    where singleChars = split (Pattern "") (toUpper w)
          sortedChars = sort singleChars


signWord :: String -> SignedWord
signWord w = { word: w
             , signature: signatureOf w
             }

signWords :: Array String -> Array SignedWord
signWords = map signWord

matchingWords :: SignedWord -> Array SignedWord -> Array SignedWord
matchingWords needle sigs = filter isAnagram sigs
    where signatureMatches w = needle.signature /= w.signature
          notSameWord w = (toUpper needle.word) /= (toUpper w.word)
          isAnagram w = (signatureMatches w) && (notSameWord w)

anagramsFor :: String -> Array String -> Array String
anagramsFor word candidates = anagrams
    where signedWords = signWords candidates
          signedNeedle = signWord word
          matching = matchingWords signedNeedle signedWords
          anagrams = map (\s -> s.word) matching
