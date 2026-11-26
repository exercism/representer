module Bob (responseFor) where

import Data.Char

responseFor :: String -> String
responseFor xs
  | null prep        = "Fine. Be that way!"
  | isShouting && last prep /= '?' = "Whoa, chill out!"
  | isShouting || last prep == '?' = "Calm down, I know what I'm doing!"
  | last prep == '?' = "Sure."
  | otherwise        = "Whatever."
  where prep = (filter (not . isSpace) . filter isPrint) xs
        isShouting = map toUpper prep == prep && any isAlpha prep
