module AtbashCipher
  ( encode
  , decode
  ) where

import Prelude

import Partial.Unsafe (unsafePartial)
import Data.Enum (fromEnum, toEnum)
import Data.String (fromCodePointArray)
import Data.String.CodePoints (CodePoint, codePointFromChar, uncons)
import Data.Maybe (Maybe(..), fromJust)
import Data.List (List(..), (:), reverse, toUnfoldable)

lowerA :: CodePoint
lowerA = codePointFromChar 'a'

lowerZ :: CodePoint
lowerZ = codePointFromChar 'z'

upperA :: CodePoint
upperA = codePointFromChar 'A'

upperZ :: CodePoint
upperZ = codePointFromChar 'Z'

zeroDigit :: CodePoint
zeroDigit = codePointFromChar '0'

nineDigit :: CodePoint
nineDigit = codePointFromChar '9'

isAsciiLower :: CodePoint -> Boolean
isAsciiLower c = c >= lowerA && c <= lowerZ

isAsciiUpper :: CodePoint -> Boolean
isAsciiUpper c = c >= upperA && c <= upperZ

isAsciiDigit :: CodePoint -> Boolean
isAsciiDigit c = c >= zeroDigit && c <= nineDigit

toLowerAscii :: CodePoint -> CodePoint
toLowerAscii c =
  if isAsciiUpper c
    then unsafePartial (fromJust (toEnum (fromEnum c + 32)))
    else c

atbashAscii :: CodePoint -> CodePoint
atbashAscii c =
  unsafePartial (fromJust (toEnum (fromEnum lowerA + fromEnum lowerZ - fromEnum c)))

-- Remove trailing space if present
stripTrailingSpace :: List CodePoint -> List CodePoint
stripTrailingSpace Nil = Nil
stripTrailingSpace xs =
  case reverse xs of
    (sp : rest) | sp == codePointFromChar ' ' -> reverse rest
    _ -> xs

encode :: String -> Maybe String
encode input =
  let
    go :: String -> Int -> List CodePoint -> List CodePoint
    go s absIdx acc = case uncons s of
      Nothing -> reverse acc
      Just { head: c, tail }
        | isAsciiLower c ->
            let c' = atbashAscii c
                acc' = 
                  if absIdx > 0 && absIdx `mod` 5 == 0
                    then c' : codePointFromChar ' ' : acc
                    else c' : acc
            in go tail (absIdx + 1) acc'
        | isAsciiUpper c ->
            let lc = toLowerAscii c
                c' = atbashAscii lc
                acc' = 
                  if absIdx > 0 && absIdx `mod` 5 == 0
                    then c' : codePointFromChar ' ' : acc
                    else c' : acc
            in go tail (absIdx + 1) acc'
        | isAsciiDigit c ->
            let acc' =
                  if absIdx > 0 && absIdx `mod` 5 == 0
                    then c : codePointFromChar ' ' : acc
                    else c : acc
            in go tail (absIdx + 1) acc'
        | otherwise ->
            go tail absIdx acc
    result = stripTrailingSpace (go input 0 Nil)
  in Just (fromCodePointArray (toUnfoldable result :: Array CodePoint))

decode :: String -> Maybe String
decode input =
  let
    go :: String -> List CodePoint -> List CodePoint
    go s acc = case uncons s of
      Nothing -> reverse acc
      Just { head: c, tail }
        | isAsciiLower c ->
            go tail (atbashAscii c : acc)
        | isAsciiDigit c ->
            go tail (c : acc)
        | otherwise ->
            go tail acc
    result = go input Nil
  in Just (fromCodePointArray (toUnfoldable result :: Array CodePoint))
