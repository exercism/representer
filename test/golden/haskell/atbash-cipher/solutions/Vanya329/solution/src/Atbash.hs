module Atbash (decode, encode) where
import Data.Char (chr, isDigit, isLetter, ord, toLower)

switch :: Char -> Char
switch c
  | isDigit c = c
  | otherwise = chr . ((-) (ord 'z' + ord 'a')) . ord . toLower $ c

format :: String -> String
format (a:b:c:d:e:f:xs) = a:b:c:d:e:' ':format (f:xs)
format xs               = xs

decode :: String -> String
decode = map switch . filter (/= ' ')

encode :: String -> String
encode = format . map switch . filter ((||) <$> isLetter <*> isDigit)