module ReverseString (reverseString) where

reverseString :: String -> String
reverseString = foldl (\x acc -> acc ++ [x]) ""
