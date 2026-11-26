module Phone (number) where

import Data.Char (isDigit)

number :: String -> Maybe String
number = not01 . prune

prune :: String -> Maybe String
prune xs
  | length s == 11 || head s == '1' = Just $ drop 1 s
  | length s == 10                  = Just s
  | otherwise                       = Nothing
  where s = filter isDigit xs

not01 :: Maybe String -> Maybe String
not01 ms = case ms of
  Just s | (s !! 0) `elem` ['2'..'9'] && (s !! 3) `elem` ['2'..'9'] -> Just s
  _                                                                 -> Nothing