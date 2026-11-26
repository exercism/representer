module Acronym (abbreviate) where

import Data.Char ( toUpper, isSpace , isLower, isLetter )

abbreviate :: String -> String
abbreviate xs = map head
              $ concatMap subwords' 
              $ map (\w -> toUpper (head w) : tail w )
              $ words' xs

boundary :: Char -> Bool
boundary c = c == '-' || isSpace c || c == '_' || c == ','

subwords' :: String -> [String]
subwords' =  splitter isLower . filter isLetter

words' :: String -> [String]
words' =  splitter boundary

splitter :: (Char -> Bool) -> String -> [String]
splitter p s =  case dropWhile p s of
                  "" -> []
                  s' -> ((head s') : w) : splitter p s''
                    where (w, s'') = break p (tail s')

