module Diamond
   (rows
   ) where

import Prelude

import Data.Array (range, replicate, reverse, zip)
import Data.Array as A
import Data.Char (fromCharCode, toCharCode)
import Data.List.Lazy (iterate)
import Data.Maybe (Maybe(..))
import Data.String (joinWith, take, length)
import Data.String.CodeUnits (fromCharArray, singleton, toCharArray)
import Data.Tuple (fst, snd)

rows:: Char -> Array String
rows c = q1q2 <> makeQuarter3n4 q1q2
  where
    halfLength = toCharCode c - toCharCode 'A' + 1
    q1 = makeQuarter1 halfLength
    q2 = makeQuarter2 q1
    q1q2 = joinQ1Q2 q1 q2


makeQuarter1 :: Int -> Array String
makeQuarter1 length = map makeQuarterLine (range 0 (length - 1))
    where
        makeQuarterLine step = joinWith "" (replicate (length - step - 1) " ") <> 
            getCharByStep step <> joinWith "" (replicate step " ")
        getCharByStep step = 
            case fromCharCode $ toCharCode 'A' + step of
            Just c' -> singleton c'
            Nothing -> ""

makeQuarter2 :: Array String -> Array String
makeQuarter2 ary = map ((\s -> take (length s - 1) s) >>> toCharArray >>> reverse >>> fromCharArray) ary

joinQ1Q2 :: Array String -> Array String -> Array String
joinQ1Q2 a1 a2 = map (\tp -> (fst tp <> snd tp)) $ zip a1 a2

makeQuarter3n4 :: Array String -> Array String
makeQuarter3n4 ary = reverse $ A.take ((A.length ary) - 1) ary
