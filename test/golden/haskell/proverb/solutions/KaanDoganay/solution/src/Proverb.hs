module Proverb(recite) where
import Data.List

recite :: [String] -> String
recite [] = []
recite [x] = "And all for the want of a " ++ x ++ "."
recite xs = joinLines (rhyme xs) ++ "\n" ++ "And all for the want of a " ++ head xs ++"."

rhyme :: [String] -> [String]
rhyme [] = []
rhyme [x] = []
rhyme (x:y:xs) = ("For want of a " ++ x ++ " the " ++ y ++ " was lost." ): rhyme (y:xs)

joinLines :: [String] -> String
joinLines = intercalate "\n"