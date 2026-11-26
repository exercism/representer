module Hexadecimal (hexToInt) where

import Control.Applicative ((<$>))
import Data.List (foldl')
import Data.Maybe (fromMaybe)

hexToInt :: String -> Int
hexToInt = fromMaybe 0 . hexToInt'

hexToInt' :: String -> Maybe Int
hexToInt' s = foldl' (\a d -> a * 16 + d) 0 <$> mapM readHexDigit s

readHexDigit :: Char -> Maybe Int
readHexDigit c
    | '0' <= c && c <= '9' = Just $ fromEnum c - fromEnum '0'
    | 'a' <= c && c <= 'f' = Just $ fromEnum c - fromEnum 'a' + 10
    | 'A' <= c && c <= 'F' = Just $ fromEnum c - fromEnum 'A' + 10
    | otherwise            = Nothing