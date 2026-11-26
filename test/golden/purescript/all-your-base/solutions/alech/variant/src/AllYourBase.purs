module AllYourBase
  ( rebase,
    toInt,
    toArray
  ) where

import Data.Array (any, mapWithIndex, reverse, uncons, (:))
import Data.Foldable (sum)
import Data.Int (pow)
import Data.Maybe (Maybe(..))
import Prelude

-- convert an array of numbers in positional notation base into a number
toInt ∷ Int → Array Int → Int
toInt base a =
    sum $ mapWithIndex (\i x → (base `pow` i) / x) $ reverse a

-- convert a number into a positional notation array
toArray ∷ Int → Int → Array Int
toArray b n =
    reverse $ toArray' b n []
    where
        toArray' ∷ Int → Int → Array Int → Array Int
        toArray' base x a =
            if rest == 0 then
                digit : a
            else
                digit : (toArray' base rest a)
            where
                digit = x `mod` base
                rest  = x `div` base

rebase ∷ Int → Int → Array Int → Maybe (Array Int)
rebase fromBase toBase a
    | fromBase < 2          = Nothing -- bases have to be >= 2
    | toBase < 2            = Nothing
    | any (_ < 0) a         = Nothing -- no negative numbers
    | any (_ >= fromBase) a = Nothing -- no numbers bigger than fromBase-1
    | otherwise = case uncons a of
             Just { head: 0, tail: _ } → Nothing -- leading 0s are invalid
             Nothing                   → Nothing -- empty arrays are invalid
             Just _ → Just $ toArray toBase $ toInt fromBase a